Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3K3Jn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:43:57 -0500
Received: from peace.netnation.com ([204.174.223.2]:60857 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3K3Jnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:43:50 -0500
Date: Sat, 30 Nov 2013 01:43:43 -0800
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20131130094343.GA12573@hostway.ca>
References: <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130820040648.GG27005@ZenIV.linux.org.uk>
 <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
 <20130820072143.GJ27005@ZenIV.linux.org.uk>
 <CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
 <20131126004456.GF19648@hostway.ca>
 <CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 03:16:09PM -0800, Linus Torvalds wrote:

> On Mon, Nov 25, 2013 at 4:44 PM, Simon Kirby <sim@hostway.ca> wrote:
> >
> > I was hoping this or something else by 3.12 would have fixed it, so after
> > testing we deployed this everywhere and turned off the rest of the debug
> > options. I missed slub_debug on one server, though...and it just hit
> > another case of overwritten poison.
> 
> Your thing is *very* consistent, it's once more four bytes into that
> pipe-info. And it's once more that exact same "increment second word
> in the allocation" pattern.
> 
> > Is it true that with slub_debug, aliasing of equal-sized objects is
> > turned off, and so they shouldn't be immediately side-by-side? In other
> > words, would there be similar scrawling victim chances as allocating
> > pipe_inode_info with pages instead of slabs? "slabinfo -a" is empty.
> 
> So the thing is, with slub debugging, slub shouldn't be merging
> different slab caches.
> 
> HOWEVER.
> 
> The pipe-info structure isn't using its own slab cache, it's just
> using "kmalloc()". So it by definition will merge with all other
> kmalloc() allocations of the same size (or, to be exact, of "similar
> enough size to hit the same size bucket"). In your case it's the
> 192-byte-sized bucket.

I turned on kmalloc-192 tracing to find what else is using it: struct
nfs_fh, struct bio, and struct cred. Poking around those, struct bio has
bi_cnt, but it is way down in the struct. struct cred has "usage", but it
comes first. Hmm. Nevertheless, I set:

CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_CREDENTIALS=y

And tried:

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec48bac..216dc43 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -168,7 +168,7 @@ static inline void *bio_data(struct bio *bio)
  * returns. and then bio would be freed memory when if (bio->bi_flags ...)
  * runs
  */
-#define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
+#define bio_get(bio)	WARN_ON(atomic_inc_return(&(bio)->bi_cnt) == 0x6c)
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 /*
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..2646fe9 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -205,7 +205,9 @@ static inline void validate_process_creds(void)
  */
 static inline struct cred *get_new_cred(struct cred *cred)
 {
-	atomic_inc(&cred->usage);
+	if (atomic_inc_return(&cred->usage) == 0x6c) {
+		WARN_ON(cred->uid == 0x6b);
+	}
 	return cred;
 }
 
On the same server, this last hunk warned fairly quickly:

[  850.303535] ------------[ cut here ]------------
[  850.312774] WARNING: CPU: 3 PID: 6169 at include/linux/cred.h:209 get_empty_filp+0x109/0x1b0()
[  850.329974] Modules linked in: ipmi_devintf aoe ipmi_si bnx2 ipmi_msghandler evdev serio_raw
[  850.346913] CPU: 3 PID: 6169 Comm: omreport Not tainted 3.12.0-hw-debug-mutexes+ #83
[  850.362374] Hardware name: Dell Inc. PowerEdge 1950/0UR033, BIOS 2.0.1 10/30/2007
[  850.377316]  0000000000000009 ffff880428d0fd28 ffffffff817f2407 ffff88043fccf9e8
[  850.392134]  0000000000000000 ffff880428d0fd68 ffffffff8105a537 ffff880428d0fd58
[  850.406936]  ffff880428d89e00 ffff88042960f480 ffff880428d0ff24 ffff88042a190000
[  850.421746] Call Trace:
[  850.426627]  [<ffffffff817f2407>] dump_stack+0x46/0x58
[  850.436888]  [<ffffffff8105a537>] warn_slowpath_common+0x87/0xb0
[  850.448878]  [<ffffffff8105a575>] warn_slowpath_null+0x15/0x20
[  850.460523]  [<ffffffff8113c7c9>] get_empty_filp+0x109/0x1b0
[  850.471818]  [<ffffffff811499c3>] path_openat+0x43/0x660
[  850.482426]  [<ffffffff8118595b>] ? fcntl_setlk+0x5b/0x2d0
[  850.493391]  [<ffffffff8114a38e>] do_filp_open+0x3e/0xa0
[  850.504008]  [<ffffffff81157bc4>] ? mntput_no_expire+0x44/0x130
[  850.515842]  [<ffffffff81156032>] ? __alloc_fd+0x42/0x110
[  850.526630]  [<ffffffff81139e9c>] do_sys_open+0x13c/0x230
[  850.537428]  [<ffffffff81187946>] compat_SyS_open+0x16/0x20
[  850.548579]  [<ffffffff81802268>] sysenter_dispatch+0x7/0x25
[  850.559888] ---[ end trace acdbea3e141dbaec ]---

All traces are the same, and all Comms are "omreport", which is from the
Dell OpenManage tools blob, executed regularly for RAID monitoring.
Running it directly does not seem to cause the warning. kern.log shows it
seems to warn every 20 minutes. No warnings from CONFIG_DEBUG_CREDENTIALS
magic checking at all.

Is there anything interesting about this tool? It is 32-bit. I can hook
path_openat() and check for the cred contents there to print the path, if
that would help.

Simon-

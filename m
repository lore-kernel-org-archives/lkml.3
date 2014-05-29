Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbaE2NMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:12:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38096 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932081AbaE2NMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:12:54 -0400
Date: Thu, 29 May 2014 09:12:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140529091251.70178abe@gandalf.local.home>
In-Reply-To: <20140529074345.GA23484@gchen.bj.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140529074345.GA23484@gchen.bj.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 03:43:45 -0400
"Chen, Gong" <gong.chen@linux.intel.com> wrote:

> On Wed, May 28, 2014 at 12:56:25PM -0400, Steven Rostedt wrote:
> > My concern is passing in a large string and wasting a lot of the ring
> > buffer space. The max you can hold per event is just under a page size
> > (4k). And all these strings add up. If it happens to be 512bytes, then
> > you end up with one event per page.
> I just don't understand why you say wasting memory. I just pass
> a char * not a string array. And most of time these strings are partial full,
> about 1/5 ~ 1/4 spaces are used.

What do you think gets recorded in the ring buffer? The pointer to the
string? No! You copy the entire string into the ring buffer, with
markers and all. How big is that string? 60 chars? 80? I see you
recording meta data there too:

 	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
-		pr_debug("bit_position: %d\n", mem->bit_pos);
+		n += scnprintf(msg + n, len - n, "bit_position: %d ",
+			       mem->bit_pos);

You record "bit_position: <number>\n"

That by itself is 15 characters not counting the number of characters
used to write the number. All you need to record for that is a two byte
type (perhaps even one byte) and a int (4 bytes) for a total of 6
bytes.  And this is just one example, you have this for all the cases.
That will fill up fast!

> 
> > 
> > Instead of making that a huge string, what about a dynamic array of
> > special structures?
> > 
> > 
> > struct __attribute__((__packed__)) cper_sec_mem_rec {
> > 	short type;
> > 	int data;
> > };
> > 
> > 
> > static struct cper_sec_mem_rec mem_location[CPER_REC_LEN];
> > 
> > then have the:
> > 
> >  	if (mem->validation_bits & CPER_MEM_VALID_NODE) {
> > 		msg[n].type = CPER_MEM_VALID_NODE_TYPE;
> > 		msg[n++].data = mem->node;
> > 	}
> > 	if (mem->validation_bits & CPER_MEM_VALID_CARD) {
> > 		msg[n].type = CPER_MEM_VALID_CARD_TYPE;
> > 		msg[n++].data = mem->card;
> > 	}
> > 	if (mem->validation_bits & CPER_MEM_VALID_MODULE) {
> > [ and so on ]
> > 
> 
> This function is not only for perf but for dmesg. So key is how
> to handle two strings: dimm_location and mem_location.
> 
> I read some __print_symbolic implementations like btrfs trace,
> 
> #define show_ref_type(type)                                     \
>         __print_symbolic(type,                                  \
>         { BTRFS_TREE_BLOCK_REF_KEY,     "TREE_BLOCK_REF" },     \
>         { BTRFS_EXTENT_DATA_REF_KEY,    "EXTENT_DATA_REF" },    \
>         { BTRFS_EXTENT_REF_V0_KEY,      "EXTENT_REF_V0" },      \
>         { BTRFS_SHARED_BLOCK_REF_KEY,   "SHARED_BLOCK_REF" },   \
>         { BTRFS_SHARED_DATA_REF_KEY,    "SHARED_DATA_REF" })
> 
> So for this case, maybe we need a macro like:
> 
> #define show_dimm_location(type)                                \
>         __print_symbolic(type,                                  \
>         { CPER_MEM_VALID_NODE,          "node" },               \
>         { CPER_MEM_VALID_CARD,          "card" },               \
>         { CPER_MEM_VALID_MODULE,        "module" },             \
>         ...
> 
> IMO, it is just another implementation method, maybe more graceful,
> but I don't know how it can save space. Again, original functions
> work both for trace and dmesg. If we add such interface, it looks
> a little bit repeated.

I'm not sure you could use that, as you save an array of data. The
print_symbolic() wont work with an array.

You can still use the same code for both the tracepoint (perf and
ftrace) and for dmesg. You need to write a packed array that is
returned as well as a way to convert that array into a human readable
string for later processing. The dmesg version would just have them
both together where as the tracepoint records the packed version on the
ring buffer and the TP_printk() will use the extraction.

That is, dmesg has the compress and extraction in one place where the
tracepoint has them in two different places.

Understand?

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaJGLas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:30:48 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:48185 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaJGLap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:30:45 -0400
Date: Tue, 7 Oct 2014 14:30:02 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>,
        Jan Kara <jack@suse.cz>, kvm@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel@nongnu.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Taras Glek <tglek@mozilla.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Jones <drjones@redhat.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Paolo Bonzini <pbonzini@redhat.com>, Keith Packard <keithp@keithp.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Minchan Kim <minchan@kernel.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mike Hommey <mh@glandium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [Qemu-devel] [PATCH 08/17] mm: madvise MADV_USERFAULT
Message-ID: <20141007113002.GE30762@node.dhcp.inet.fi>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-9-git-send-email-aarcange@redhat.com>
 <20141007103645.GB30762@node.dhcp.inet.fi>
 <20141007104603.GI2404@work-vm>
 <20141007105245.GC30762@node.dhcp.inet.fi>
 <20141007110102.GJ2404@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007110102.GJ2404@work-vm>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:01:02PM +0100, Dr. David Alan Gilbert wrote:
> * Kirill A. Shutemov (kirill@shutemov.name) wrote:
> > On Tue, Oct 07, 2014 at 11:46:04AM +0100, Dr. David Alan Gilbert wrote:
> > > * Kirill A. Shutemov (kirill@shutemov.name) wrote:
> > > > On Fri, Oct 03, 2014 at 07:07:58PM +0200, Andrea Arcangeli wrote:
> > > > > MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
> > > > > vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
> > > > > userland touches a still unmapped virtual address, a sigbus signal is
> > > > > sent instead of allocating a new page. The sigbus signal handler will
> > > > > then resolve the page fault in userland by calling the
> > > > > remap_anon_pages syscall.
> > > > 
> > > > Hm. I wounder if this functionality really fits madvise(2) interface: as
> > > > far as I understand it, it provides a way to give a *hint* to kernel which
> > > > may or may not trigger an action from kernel side. I don't think an
> > > > application will behaive reasonably if kernel ignore the *advise* and will
> > > > not send SIGBUS, but allocate memory.
> > > 
> > > Aren't DONTNEED and DONTDUMP  similar cases of madvise operations that are
> > > expected to do what they say ?
> > 
> > No. If kernel would ignore MADV_DONTNEED or MADV_DONTDUMP it will not
> > affect correctness, just behaviour will be suboptimal: more than needed
> > memory used or wasted space in coredump.
> 
> That's not how the manpage reads for DONTNEED; it calls it out as a special
> case near the top, and explicitly says what will happen if you read the
> area marked as DONTNEED.

Your are right. MADV_DONTNEED doesn't fit the interface too. That's bad
and we can't fix it. But it's not a reason to make this mistake again.

Read the next sentence: "The kernel is free to ignore the advice."

Note, POSIX_MADV_DONTNEED has totally different semantics.

> It looks like there are openssl patches that use DONTDUMP to explicitly
> make sure keys etc don't land in cores.

That's nice to have. But openssl works on systems without the interface,
meaning it's not essential for functionality.

-- 
 Kirill A. Shutemov

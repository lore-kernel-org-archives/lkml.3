Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaIGVbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 17:31:21 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:61807 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaIGVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 17:31:19 -0400
Date: Sun, 7 Sep 2014 14:31:17 -0700
From: Peter Feiner <pfeiner@google.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140907213117.GA388@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
 <20140904164311.GA29610@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904164311.GA29610@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:43:11AM -0700, Peter Feiner wrote:
> On Mon, Aug 25, 2014 at 09:45:34PM -0700, Hugh Dickins wrote:
> > That sets me wondering: have you placed the VM_SOFTDIRTY check in the
> > right place in this series of tests?
> > 
> > I think, once pgprot_modify() is correct on all architectures,
> > it should be possible to drop that pgprot_val() check from
> > vma_wants_writenotify() - which would be a welcome simplification.
> > 
> > But what about the VM_PFNMAP test below it?  If that test was necessary,
> > then having your VM_SOFTDIRTY check before it seems dangerous.  But I'm
> > hoping we can persuade ourselves that the VM_PFNMAP test was unnecessary,
> > and simply delete it.
> 
> If VM_PFNMAP is necessary, then I definitely put the VM_SOFTDIRTY check in the
> wrong spot :-) I don't know much (i.e., anything) about VM_PFNMAP, so I'll
> have to bone up on a lot of code before I have an informed opinion about the
> necessity of the check.

AFAICT, the VM_PFNMAP check is unnecessary since I can't find any drivers that
set VM_PFNMAP and enable dirty accounting on their mappings. If anything,
VM_PFNMAP precludes mapping dirty tracking since set_page_dirty takes a
struct_page argument! Perhaps the VM_PFNMAP check was originally put in
vma_wants_writenotify as a safeguard against bogus calls to set_page_dirty?
In any case, it seems harmless to me to put the VM_SOFTDIRTY check before the
VM_PFNMAP check since none of the fault handling code in mm/memory.c calls
set_page_dirty on a VM_PFNMAP fault because either vm_normal_page() returns
NULL or ->fault() / ->page_mkwrite() return VM_FAULT_NOPAGE. Moreover, for
the purpose of softdirty tracking, enabling write notifications on VM_PFNMAP
VMAs is OK since do_wp_page does the right thing when vm_normal_page() returns
NULL.

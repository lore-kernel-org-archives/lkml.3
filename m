Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3HUOxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:53:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36017 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3HUOxm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Wed, 21 Aug 2013 10:53:42 -0400
Message-Id: <5214F09002000078000ED5C3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 21 Aug 2013 15:53:36 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts
 with existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon>
In-Reply-To: <20130821141223.GS18673@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.08.13 at 16:12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Aug 21, 2013 at 02:48:20PM +0100, David Vrabel wrote:
>> All,
>> 
>> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
>> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
>> and _PTE_PAT.
>> 
>> With a Xen PV guest, the use of the _PTE_PAT will result in the page
>> having unexpected cachability which will introduce a range of subtle
>> performance and correctness issues.  Xen programs the entry 4 in the PAT
>> table with WC so a page that was previously WB will end up as WC.
>> 
> 
> David, could you please explain, Xen keeps and analyze _PTE_PAT bit
> for ptes which are not present?

No, the problem isn't with not-present PTEs (i.e. swap entries),
but with present ones - the same bit (7) is being used for both,
according to this comment:

/*
 * Tracking soft dirty bit when a page goes to a swap is tricky.
 * We need a bit which can be stored in pte _and_ not conflict
 * with swap entry format. On x86 bits 6 and 7 are *not* involved
 * into swap entry computation, but bit 6 is used for nonlinear
 * file mapping, so we borrow bit 7 for soft dirty tracking.
 */

Or are you telling me that the comment is misleading (at least me),
and this applies only to not-present PTEs? And even then - where
would the value of the original PAT bit be stored while swapped
out (or is it impossible - now and forever - for WC pages to get
swapped)?

Jan


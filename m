Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936611AbaH1LKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:10:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33273 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487AbaH1LKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:10:03 -0400
Date: Thu, 28 Aug 2014 13:09:56 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Chip <chip.programmer@att.net>, linux-kernel@vger.kernel.org
Subject: Re: amd_mce.c redundant if check?
Message-ID: <20140828110956.GC4818@rric.localhost>
References: <A94C429ECA0745D9802830213B114DFE@chip>
 <20140822045516.GC11381@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822045516.GC11381@nazgul.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.14 06:55:16, Borislav Petkov wrote:
> On Wed, Aug 20, 2014 at 10:08:18PM -0600, Chip wrote:
> > Now, if the return from lvt_off_valid() is false, then nothing is
> > changed in "hi".  However, if the return is true, which means the
> > value in tr->lvt_off is equal to the LVTOFF value in "hi", then the
> > LVTOFF value in "hi" is replaced with the value in tr->lvt_off.  One
> > has to wonder, then, why bother actually calling lvt_off_valid() in
> > the first place when the end result is that "hi" does not change.
> > What is the rationale for having the code snippet at lines 170 - 176
> > when that condition check does nothing to change "hi"?
> 
> Right, I see what you mean now. This is
> 
> bbaff08dca3c ("mce, amd: Add helper functions to setup APIC")
> 
> Frankly, I'm not too worried about the overwriting the LVT offset with
> the same value in the success case - that doesn't hurt anyone.

The main purpose of lvt_off_valid() is to check the initial msr
settings provided by the bios and to throw a FW_BUG message if there
is anything wrong.

The MCE offset must be the same for all banks on all cores at every
time and it must be different to all other vectors, esp. IBS, on all
other cores. APIC settings also get lost after suspend/resume
(different for suspend to disk or ram), this needs to be handled too.

We have seen bioses there this was completely messed up having
different offsets for different banks or same offsets for mce and
ibs. Note that mce is used only on cpu 0 of each node while ibs is
used on every cpu of a node. This makes things even more complex as
you may not use an unused offset on a particular core since this
offset is already used on a different core of the same node.

For these reasons we track offsets in sw which is implemented in
setup_APIC_eilvt().

For mce there is no offset valid bit as for ibs and sw assumes lvt_off
to be always valid. This value is used in setup_APIC_mce() to setup
the apic. If there is already an offset for mce registered, that
current offset is returned instead of the new one, see
mce_amd_feature_init():

                        if (b.interrupt_capable) {
                                int new = (high & MASK_LVTOFF_HI) >> 20;
                                offset  = setup_APIC_mce(offset, new);
                        }

                        mce_threshold_block_init(&b, offset);

'offset' and 'new' may differ then because of a bios bug. In this case
a FW_BUG message is thrown.

Now, I agree with you that current implementation does not allow to
program different offsets than provided by the msr. So we allow to
overwrite the vector only if the value is the same which is needless
and this code may be removed. But for !lvt_off_valid which is the case
if we observe a different offset, we have a bios bug and do not expect
mces to work properly. Maybe we disable interrupts at all then.  But
so far this wasn't an issue.

The check is needed in any case to throw FW bug messages.

-Robert

> What is more interesting is what we do in the !lvt_off_valid case... I
> don't think we should be writing the MSR at all at the end but just exit
> early. But I've long forgotten the details of the whole APIC vectors
> deal we thought up at the time.

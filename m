Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3JYPyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:54:44 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47173 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3JYPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:54:42 -0400
Date: Fri, 25 Oct 2013 20:53:55 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Message-ID: <20131025155353.GB4263@gmail.com>
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
 <20130807084054.GA18668@lee--X1>
 <52667A6C.6000301@linutronix.de>
 <20131022154846.GA24024@lee--X1>
 <5266A79D.8020208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5266A79D.8020208@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:28:13PM +0200, Sebastian Andrzej Siewior wrote:
> On 10/22/2013 05:48 PM, Lee Jones wrote:
> > On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:
> > 
> >> On 08/07/2013 10:40 AM, Lee Jones wrote:
> >>> On Mon, 05 Aug 2013, Zubair Lutfullah wrote:
> >>>
> >>>> Reg_cache variable is used to lock step enable register
> >>>> from being accessed and written by both TSC and ADC
> >>>> at the same time.
> >>>> However, it isn't updated anywhere in the code at all.
> >>>>
> >>>> If both TSC and ADC are used, eventually 1FFFF is always
> >>>> written enabling all 16 steps uselessly causing a mess.
> >>>>
> >>>> Patch fixes it by correcting the locks and updates the
> >>>> variable by reading the step enable register
> >>>>
> >>>> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> >>>> ---
> >>>>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> Better that it comes from somewhere.
> >>
> That means I don't understand the commit message. It says
> "However, it isn't updated anywhere in the code at all." but as you see
> all three functions (set, update) are used. You said "Better that it
> comes from somewhere" so I assumed since two people were looking at
> this I forgot something.
> 
> >> It has been initialized to 0 by time the mfd part was loaded and
> >> updated via …_set() from both parts (TSC & ADC). 
> >> The lock ensured that
> >> we never lose or add bits due to a race. So I don't understand why we
> >> end up with 0x1FFFF.
> >> Could some please explain to me how this can happen?

Let me elaborate this.

If I enable TSC(4 wire) and ADC Channel 1 and 2 (out of channels 0,1,2,3).

In the previous code, I would get reg_se_cache variable as 0x1FFF6. Two bits zero
as channel 0 and 3 are disabled. And the rest of the steps enabled for TSC.

Now I disable ADC channel 1 and 2. And enable ADC channel 0 and 3.
In the previous code, I would then get reg_se_cache variable as 0x1FFFF. There 
was no code to zero the bits of the disabled channels.

am335x_tsc_se_set was used effectively.
but am335x_tsc_se_clr was only used in the drivers _remove function.

Over time, the variable reg_se_cache would become 0x1FFFF.

Enabled steps in REG_SE become 0 in ADC single shot mode.
Enabled steps in REG_SE become 0 in TSC events as well.

But in continuous sampling mode for ADC,  REG_SE steps
for those channels remain enabled.

This required the patches.
REG_SE is read in am335x_tsc_se_set so that the enabled steps of the ADC 
are read when the TSC is enabling its steps after an event.

> >> I added reg_se_cache to cache the content of REG_SE once and
> >> synchronize it among TSC & ADC access. REG_SE is set to 0 by the HW
> >> after "work" has been done. So you need to know the old value or TSC may
> >> disable ADC and the other way around.
> >>
> >> In tree (staging-next) I see that reg_se_cache ended being pointless.
> >> am335x_tsc_se_update() is no longer used from TSC or ADC. Only the
> >> _set() and _clr() functions are used which (both) read back the content
> >> of the REG_SE register before calling am335x_tsc_se_update().
> > 
> > Not sure I get this point.
> 
> The point is that reg_se_cache is (under the lock) set to the value
> read from the HW, ORed by the value which is passed as an argument and
> then written back to HW. This makes the reg_se_cache in the struct
> pointless and a local variable would do the same job.

Haven't looked at the code again. But if I remember correctly,
This makes sense. There is room for optimization and reg_se_cache
is useless now?

> 
> > 
> >> That makes me think that we might cut of one part by accident. On the
> >> other hand Zubair said that he tested using ADC & TSC at the same time
> >> and it worked. So I have to double check if the HW really resets the
> >> content back to zero or not; maybe there is another explanation :)
> >>

I'm still in the wedding mode. But thought I'd reply to these queries.
The HW worked when I tested it..

> >> One thing that is an issue is that now the _set() function is using the
> >> lock without disabling interrupts and is called from non-IRQ
> >> (tiadc_read_raw()) and IRQ (titsc_irq()) context which might lead to
> >> deadlock. I'm going to send a patch for this.
> > 
> > I see the patch, but let's sort this out first, before I apply it.
> 
> Please apply the patch to fix the possible deadlock situation which we
> will have in the next merge window. I didn't revert or made any other
> changes just have this sorted out in time while the deadlock is gone.
> 

Noticed it and forgot. Sorry.

I hope this clears the confusion.
There is room for some optimization. The se_cache variable can be removed now
I think.

Zubair

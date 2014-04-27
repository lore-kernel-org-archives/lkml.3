Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaD0XNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 19:13:25 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:54483 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaD0XNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 19:13:23 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <20140427185708.GA15007@rhlx01.hs-esslingen.de>
Message-ID: <cone.1398640399.709208.1804.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andreas Mohr <andi@lisas.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/4] acerhdf/thermal: adding new models and appropriate
         governor
Date: Mon, 28 Apr 2014 01:13:19 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Mohr writes:

> On Sun, Apr 27, 2014 at 03:23:31AM +0200, Peter Feuerer wrote:
>> This patch series is intended to:
>> 
>>   * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
>>     the fan of a few new models.  Unfortunately this extends lines defining
>>     the bios table over 80 characters, but all other methods make the code
>>     really ugly and hard to read.  So I hope for the reason of readability it
>>     is ok to break this rule.
> 
> Hmm... got an idea there. Possibly it's time to do away with direct
> "device name" <-> open-coded config data mappings.
> After all a specific device name is not really all too meaningful,
> can (and will) be invented out of thin air, with its reg config being
> identical to (read: painfully duplicated)
> several other names/BIOS versions in the series.
> So perhaps one should have a helper struct defined,
> with instances then named as particular base samples of a model series
> (ideally named after the precise internal development code name of the series),
> to then be referenced by all model/BIOS names which match.
> 
> struct {
>   struct reg_feat_1;
>   struct reg_feat_2;
> } aao_reg_map;
> 
> static const aao_reg_map aao_reg_map_AOAxxx_Acer_orig_version;
> 
> 
> 
> 
> { "Acer", "AOA1....", &aao_reg_map_AOAxxx_Acer_orig_version },
> 
> Of course you then have the indirection of device name <-> specific
> register values (quote: "really ugly and hard to read"?),
> but IMHO that's ok since normally you wouldn't be too focused
> on looking up register values (...right!?).
> 
> And if the next interface-breaking config change came along,
> you'd otherwise have to add yet another register index pair...
> (at which point some 100+ char line monsters
> would be breathing down our neck...)

I think we have been discussing this solution a year ago or something and 
seems like it is really time to implement it.  As I wrote in the other mail 
to Boris, I'd like to just do a minor modification for now and then when 
those 4 patches have been applied concentrate on implementing the splitted 
structs.


> Model additions:
> Ain't there one MODULE_ALIAS missing?? (7 new models <-> 6 entries!?!?)
>     "Aspire One 753"? But perhaps that's already implicitly covered by
> another existing entry? [if so, the commit log did not mention it ;)]

You are right, alias for 753 is missing, will add it for the next patch set.


>>   * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
>>     fiddling around with the step-wise governor has been a very fragile thing
>>     in the past and as it broke again, I used the opportunity to add a two
>>     point thermal governor which implements the actual fan handling required by
>>     acerhdf and puts from my point of view things straight.
> 
> I'm afraid I don't have the full picture,
> but so far it seems that this factoring out of common handling
> is a very good idea.

ok.


> -       depends on THERMAL && ACPI
> +       depends on THERMAL && ACPI && THERMAL_GOV_BANG_BANG
> Do we actively depend on THERMAL (code-wise, I mean?) Or is it now an
> implicit dependency given that we request THERMAL_GOV_BANG_BANG? If
> implicit, then THERMAL probably ought to be removed. But if we use
> generic thermal APIs (which we probably do), then of course we do have
> that dependency....

There's an implicit dependency due to the request of THERMAL_GOV_BANG_BANG, so
yes, we could remove THERMAL here.


> "bang_bang_throttle - throttles devices asscciated with the given zone"
> 
> Typo ;)

c != o, got it.


> "used to force thermal" --> misleading ("we used to do this, but it's
> bad so we better do that").
> 
> "intended to"? "established to"? "added to"? or some simpler wording?

What do you think about this wording:
/*
 * this struct is used to instruct thermal layer to use bang_bang instead of
 * default governor for acerhdf
 */


> pr_err("Thermal governor %s is not compiled into thermal subsystem\n"
>     --> you are lying here... (the only thing we can reliably indicate
>         is that we did not get the expected name -
>         so we should perhaps indicate something like we "didn't get bang-bang,
>         since perhaps not compiled into thermal subsystem").

Fixed in next submit.


>> Please test/review the patches and send me your comments.
> 
> -ENODATA (my crappy JMicron JMF601 SSD had managed to break again,
>     this time with fatal firmware corruption, so I had to reflash
>     firmware to resurrect it, but I haven't restored my environment yet,
>     but I'll obviously report back immediately if something comes up)

Ok, good luck with this.

Thanks for all the good input.

-- 
kind regards,
--peter;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3C1SHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:07:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41476 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3C1SG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:06:59 -0400
Date: Thu, 28 Mar 2013 19:06:45 +0100
From: Richard GENOUD <richard.genoud@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pinctrl: re-enable old state in case of error in
 pinctrl_select_state
Message-ID: <20130328180643.GB10420@lnx-rg>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
 <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
 <51538701.60409@wwwdotorg.org>
 <20130328173356.GA10420@lnx-rg>
 <5154800F.1040007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5154800F.1040007@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [jeu., 28.03.2013 11:38:23], Stephen Warren wrote:
> On 03/28/2013 11:34 AM, Richard GENOUD wrote:
> > On [mer., 27.03.2013 17:55:45], Stephen Warren wrote:
> >> On 03/25/2013 08:47 AM, Richard Genoud wrote:
> >>> If a new state is applied, the groups configured in the old state but
> >>> not in the new state are disabled.
> >>> If something goes wrong and the new state can't be applied, we have to
> >>> re-enable those groups.
> >>
> >> What is the use-case for this? I wonder if it isn't better to simply
> >> undo the partial selection of the new state (as patch 3/4 attempts to
> >> do) and then leave p->state==NULL, indicating that no state is actively
> >> selected. IIRC, this would be the same as right after the initial
> >> pinctrl_select().
> >>
> >> I wonder if it's likely that attempting to re-apply the old state would
> >> actually work, given that applying something just failed.
> >>
> >> Finally, this recovery code doesn't:
> >>
> >> a) Process anything except MUX_GROUP; any pin config settings in the old
> >> state aren't restored.
> >>
> >> b) (I think) Apply any mux settings that don't involve groups that are
> >> referenced by both the old and new states; given that patch 3/4 attempts
> >> to undo everything in the failed application of the new state, I think
> >> this "re-apply the old state" code should simple run through everything
> >> in the old state any apply it unconditionally.
> >
> > So, if I understand correctly, it could be as simple as that:
> >  	}
> >  
> > -	if (old_state) {
> > -		list_for_each_entry(setting, &old_state->settings, node) {
> > -			bool found = false;
> > -			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
> > -				continue;
> > -			list_for_each_entry(setting2, &state->settings, node) {
> > -				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
> > -					continue;
> > -				if (setting2->data.mux.group ==
> > -						setting->data.mux.group) {
> > -					found = true;
> > -					break;
> > -				}
> > -			}
> > -			if (!found)
> > -				pinmux_enable_setting(setting);
> > -		}
> > -	}
> > -
> >  	p->state = old_state;
> 
> I think you want to remove that line too, so that p->state == NULL in
> the error case, so that if the pinctrl_select_state_locked() call below
> also fails to restore the old state, then (!old_state) will be true
> inside the recursive call, so it doesn't recurse into itself forever.
> 
> > +	if (old_state)
> > +		pinctrl_select_state_locked(p, NULL);
> 
> You want to pass old_state rather than NULL there, I think.
Hum, I'm starting to code nonsense. It's time to go home !

But yes, we clearly don't want to have p->state != NULL in the recursive
call (I've seen that, and an evil force made me wrote the contrary :))

So, just:
+	if (old_state)
+		pinctrl_select_state_locked(p, old_state);
Will do the trick.
It can't loop forever as p->state is null.
If it fails, p->state will be still null.
If it succeeds, p->state will be == old_state, and that's what we want.

Got it !(finally)


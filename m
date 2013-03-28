Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3C1ReS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:34:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40253 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3C1ReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:34:17 -0400
Date: Thu, 28 Mar 2013 18:34:00 +0100
From: Richard GENOUD <richard.genoud@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pinctrl: re-enable old state in case of error in
 pinctrl_select_state
Message-ID: <20130328173356.GA10420@lnx-rg>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
 <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
 <51538701.60409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51538701.60409@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [mer., 27.03.2013 17:55:45], Stephen Warren wrote:
> On 03/25/2013 08:47 AM, Richard Genoud wrote:
> > If a new state is applied, the groups configured in the old state but
> > not in the new state are disabled.
> > If something goes wrong and the new state can't be applied, we have to
> > re-enable those groups.
> 
> What is the use-case for this? I wonder if it isn't better to simply
> undo the partial selection of the new state (as patch 3/4 attempts to
> do) and then leave p->state==NULL, indicating that no state is actively
> selected. IIRC, this would be the same as right after the initial
> pinctrl_select().
> 
> I wonder if it's likely that attempting to re-apply the old state would
> actually work, given that applying something just failed.
> 
> Finally, this recovery code doesn't:
> 
> a) Process anything except MUX_GROUP; any pin config settings in the old
> state aren't restored.
> 
> b) (I think) Apply any mux settings that don't involve groups that are
> referenced by both the old and new states; given that patch 3/4 attempts
> to undo everything in the failed application of the new state, I think
> this "re-apply the old state" code should simple run through everything
> in the old state any apply it unconditionally.
So, if I understand correctly, it could be as simple as that:
 	}
 
-	if (old_state) {
-		list_for_each_entry(setting, &old_state->settings, node) {
-			bool found = false;
-			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
-				continue;
-			list_for_each_entry(setting2, &state->settings, node) {
-				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
-					continue;
-				if (setting2->data.mux.group ==
-						setting->data.mux.group) {
-					found = true;
-					break;
-				}
-			}
-			if (!found)
-				pinmux_enable_setting(setting);
-		}
-	}
-
 	p->state = old_state;
+
+	if (old_state)
+		pinctrl_select_state_locked(p, NULL);
+
 	return ret;
 }

> 
> c) Set p->state = oldstate, so it's left at NULL, which would confuse
> any future pinctrl_select().

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3C0Xzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:55:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35268 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3C0Xzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:55:48 -0400
Message-ID: <51538701.60409@wwwdotorg.org>
Date: Wed, 27 Mar 2013 17:55:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pinctrl: re-enable old state in case of error in
 pinctrl_select_state
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com> <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:47 AM, Richard Genoud wrote:
> If a new state is applied, the groups configured in the old state but
> not in the new state are disabled.
> If something goes wrong and the new state can't be applied, we have to
> re-enable those groups.

What is the use-case for this? I wonder if it isn't better to simply
undo the partial selection of the new state (as patch 3/4 attempts to
do) and then leave p->state==NULL, indicating that no state is actively
selected. IIRC, this would be the same as right after the initial
pinctrl_select().

I wonder if it's likely that attempting to re-apply the old state would
actually work, given that applying something just failed.

Finally, this recovery code doesn't:

a) Process anything except MUX_GROUP; any pin config settings in the old
state aren't restored.

b) (I think) Apply any mux settings that don't involve groups that are
referenced by both the old and new states; given that patch 3/4 attempts
to undo everything in the failed application of the new state, I think
this "re-apply the old state" code should simple run through everything
in the old state any apply it unconditionally.

c) Set p->state = oldstate, so it's left at NULL, which would confuse
any future pinctrl_select().

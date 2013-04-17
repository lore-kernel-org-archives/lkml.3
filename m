Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab3DQPVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:21:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54595 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3DQPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:21:34 -0400
Message-ID: <516EBDFA.90201@wwwdotorg.org>
Date: Wed, 17 Apr 2013 09:21:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laurent MEUNIER <laurent.meunier@st.com>
CC: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl/pinconfig: add debug interface
References: <1365018447-28062-1-git-send-email-linus.walleij@stericsson.com> <515DEC92.9010602@wwwdotorg.org> <516EB2B7.30607@st.com>
In-Reply-To: <516EB2B7.30607@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 08:33 AM, Laurent MEUNIER wrote:
> On 04/04/2013 11:11 PM, Stephen Warren wrote:
>> On 04/03/2013 01:47 PM, Linus Walleij wrote:
>>> From: Laurent Meunier <laurent.meunier@st.com>
>>>
>>> This update adds a debugfs interface to modify a pin configuration
>>> for a given state in the pinctrl map. This allows to modify the
>>> configuration for a non-active state, typically sleep state.
>>> This configuration is not applied right away, but only when the state
>>> will be entered.
>>>
>>> This solution is mandated for us by HW validation: in order
>>> to test and verify several pin configurations during sleep without
>>> recompiling the software.
>>>
>>> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
>>> +enum pinconf_dbg_request_type {
>>> +	PINCONF_DBG_REQ_TYPE_INVALID,
>>> +	PINCONF_DBG_REQ_TYPE_MODIFY,
>>> +};
>> I'm not sure why that really needs an enum yet, since only one operation
>> is supported.
>
> I agree the enum does not bring a lot of added value, for now.
> It is there following one earlier comment that the debugfs
> could be later extended to support ADD / DELETE. This is
> a preparation step to this, so I've kept it in in my V3.
> Hope this is fine.

That seems like something that could easily be added later. right now,
it's just dead code. I'll let LinusW make the call though.

>>> +struct dbg_cfg {
>>> +	enum pinconf_dbg_request_type req_type;
>>> +	enum pinctrl_map_type map_type;
>>> +	char dev_name[MAX_NAME_LEN+1];
>>> +	char state_name[MAX_NAME_LEN+1];
>>> +	char pin_name[MAX_NAME_LEN+1];
>>> +	char config[MAX_NAME_LEN+1];
>>> +};
>
>> Many of those fields are only used internally to
>> pinconf_dbg_config_write(). Can't they be stored on the stack there
>> rather than globally.
>
> I'd like to get the context as a global to share it between _print()
> and _write() functions. I find it quite useful in practice
> basically when using the debugfs, after the write request,
> you can simply cat pinconf-config and check the status of
> what you've last written to. This is the rationale at least.

Data that truly is shared between print() and write() would have to be
global. My point is that many of those fields are not shared, and hence
there's no point making them global.

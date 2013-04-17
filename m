Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966649Ab3DQOdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:33:52 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:40531 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966477Ab3DQOdv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:33:51 -0400
From: Laurent MEUNIER <laurent.meunier@st.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 17 Apr 2013 16:33:27 +0200
Subject: Re: [PATCH v2] pinctrl/pinconfig: add debug interface
Thread-Topic: [PATCH v2] pinctrl/pinconfig: add debug interface
Thread-Index: Ac47eIZOpkqmwjNkRFq0Mbb0ZZ0Adg==
Message-ID: <516EB2B7.30607@st.com>
References: <1365018447-28062-1-git-send-email-linus.walleij@stericsson.com>
 <515DEC92.9010602@wwwdotorg.org>
In-Reply-To: <515DEC92.9010602@wwwdotorg.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:11 PM, Stephen Warren wrote:
> On 04/03/2013 01:47 PM, Linus Walleij wrote:
>> From: Laurent Meunier <laurent.meunier@st.com>
>>
>> This update adds a debugfs interface to modify a pin configuration
>> for a given state in the pinctrl map. This allows to modify the
>> configuration for a non-active state, typically sleep state.
>> This configuration is not applied right away, but only when the state
>> will be entered.
>>
>> This solution is mandated for us by HW validation: in order
>> to test and verify several pin configurations during sleep without
>> recompiling the software.
>>
>> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
>> +enum pinconf_dbg_request_type {
>> +	PINCONF_DBG_REQ_TYPE_INVALID,
>> +	PINCONF_DBG_REQ_TYPE_MODIFY,
>> +};
> I'm not sure why that really needs an enum yet, since only one operation
> is supported.
I agree the enum does not bring a lot of added value, for now.
It is there following one earlier comment that the debugfs
could be later extended to support ADD / DELETE. This is
a preparation step to this, so I've kept it in in my V3.
Hope this is fine.

>> +struct dbg_cfg {
>> +	enum pinconf_dbg_request_type req_type;
>> +	enum pinctrl_map_type map_type;
>> +	char dev_name[MAX_NAME_LEN+1];
>> +	char state_name[MAX_NAME_LEN+1];
>> +	char pin_name[MAX_NAME_LEN+1];
>> +	char config[MAX_NAME_LEN+1];
>> +};
> Many of those fields are only used internally to
> pinconf_dbg_config_write(). Can't they be stored on the stack there
> rather than globally.
I'd like to get the context as a global to share it between _print()
and _write() functions. I find it quite useful in practice
basically when using the debugfs, after the write request,
you can simply cat pinconf-config and check the status of
what you've last written to. This is the rationale at least.

>> +/**
>> + * pinconf_dbg_config_print() - display the pinctrl config from the pinctrl
>> + * map, of a pin/state pair based on pinname and state that have been
>> + * selected with the debugfs entries pinconf-name and pinconf-state
>> + * @s: contains the 32bits config to be written
>> + * @d: not used
>> + */
> This comment seems stale; I don't believe there are any pinconf-name and
> pinconf-state files; aren't they part of the data written to the one
> debugfs file each time?
Right. Comment definitely needs update.
>
>> +static int pinconf_dbg_config_print(struct seq_file *s, void *d)
>> +		if (strncmp(map->dev_name, dbg->dev_name, MAX_NAME_LEN) != 0)
> Wouldn't it be simpler to always ensure dbg->dev_name was
> NULL-terminated, and just use !strcmp() here? Same for dbg->state_name
> below. Same comment for the other function below.
Yes that looks better.
>> +	mutex_unlock(&pinctrl_mutex);
> Don't you need the lock held to call confops->xxx() below, to make sure
> that the driver isn't unregistered between finding it, and calling the
> confops function?
Right as well.
>
>> +	if (!found) {
>> +		seq_printf(s, "No config found for dev/state/pin, expected:\n");
>> +		seq_printf(s, "modify config_pins devname " \
>> +			   "state pinname value\n");
>> +	}
> Hmmm. At least including the parsed values that were being searched for
> might be useful?
Right as well.
>
>> +		confops->pin_config_config_dbg_show(pctldev,
>> +						    s, config);
> I think that function name is wrong; two "config_" in a row. Does this
> compile?
Yes it compiles. The pinconf_ops contains an operation named
  like this (pin_config_config_dbg_show) and I think this is the one we 
need here.
>
>> +/**
>> + * pinconf_dbg_config_write() - overwrite the pinctrl config in the pinctrl
>> + * map, of a pin/state pair based on pinname and state that have been
>> + * selected with the debugfs entries pinconf-name and pinconf-state
> Similar stale comment.
Yes, right.
>
>> + * @user_buf: contains 'modify configs_pin devicename state pinname newvalue'
> It might be useful to say which parts of that are literal strings and
> which are variables/values to be changed?
Yes also part of update needed in the comment
>
>> +static int pinconf_dbg_config_write(struct file *file,
>> +	const char __user *user_buf, size_t count, loff_t *ppos)
>> +	/* Get arg: 'modify' */
>> +	if (!strncmp(b, "modify ", strlen("modify "))) {
>> +		dbg->req_type = PINCONF_DBG_REQ_TYPE_MODIFY;
>> +		b += strlen("modify ");
>> +	} else {
>> +		return -EINVAL;
>> +	}
> There's rather a lot of duplication of strings and strlen calls there.
> Why not:
>
> a) Start using strsep() for the very first fields too, so everything is
> consistent.
>
> b) Put the error-path first.
>
> In other words:
>
> 	token = strsep(&b, " ");
> 	if (!token)
> 		return -EINVAL;
> 	if (!strcmp(token, "modify"))
> 		return -EINVAL;
Thanks for the proposal, code looks indeed better like this
>> +	/* Get arg type: "config_pin" type supported so far */
>> +	if (!strncmp(b, "config_pins ", strlen("config_pins "))) {
>> +		dbg->map_type = PIN_MAP_TYPE_CONFIGS_PIN;
>> +		b += strlen("config_pins ");
>> +	} else {
>> +		return -EINVAL;
>> +	}
> That could be transformed the same way.
>
>> +	/* get arg 'device_name' */
>> +	token = strsep(&b, " ");
>> +	if (token == NULL)
>> +		return -EINVAL;
>> +	if (strlen(token) < MAX_NAME_LEN)
>> +		sscanf(token, "%s", dbg->dev_name);
>> +	else
>> +		return -EINVAL;
> It might make sense to put the error-handling first, and why sscanf not
> strcpy? So:
>
> 	token = strsep(&b, " ");
> 	if (token == NULL)
> 		return -EINVAL;
> 	if (strlen(token) >= MAX_NAME_LEN)
> 		return -EINVAL;
> 	strcpy(dbg->dev_name, token);
>
> (or even just use strncpy followed by explicit NULL termination and
> truncate text that's too long, or kstrdup() it to avoid limits?)
Same here. Looks better
>
>> +	if (confops && confops->pin_config_dbg_parse) {
>> +		for (i = 0; i < configs->num_configs; i++) {
>> +			confops->pin_config_dbg_parse(pctldev,
>> +						    dbg->config,
>> +						    &configs->configs[i]);
> I assume that "parse" function is intended to actually write the new
> result into configs->configs[i]. That's more than parsing.
> s/dbg_parse/dbg_modify/ perhaps to make this more explicit, and also
> mention this in the kerneldoc for the confops structure in the header?
I ended up with ->pin_config_dbg_parse_modify(). Hope this is ok.
Linus will post a V3 version including above needed updates.
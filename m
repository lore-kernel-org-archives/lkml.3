Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3IIGDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:03:00 -0400
Received: from hurricane.the-brannons.com ([64.62.188.119]:39970 "EHLO
	hurricane.the-brannons.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab3IIGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:02:59 -0400
From: Chris Brannon <chris@the-brannons.com>
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>, Kirk Reiser <kirk@reisers.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
	<87fvtefy10.fsf@mushroom.PK5001Z>
	<CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
Date: Sun, 08 Sep 2013 23:02:57 -0700
In-Reply-To: <CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
	(Raphael S. Carvalho's message of "Mon, 9 Sep 2013 01:14:15 -0300")
Message-ID: <87y576edm6.fsf@mushroom.PK5001Z>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raphael S Carvalho <raphael.scarv@gmail.com> writes:

> Wouldn't the following code (right before the statement: if
> (param->var_id == VOICE)) 
> check if value is out of range?
>
> value = simple_strtol(cp, NULL, 10);
> ret = spk_set_num_var(value, param, len);
> if (ret == -ERANGE) {
> var_data = param->data;
> pr_warn("value for %s out of range, expect %d to %d\n",
> param->name,
> var_data->u.n.low, var_data->u.n.high);
> }

That code prints an error message if the value is out of range.  Also,
since spk_set_num_var returns -ERANGE, we know that spk_set_num_var
didn't set anything.
But we use value again later in the function, if param->var_id ==
VOICE.  In that second use, we don't check to see if value is in range.
So if I set voice to something nonsensical, like 234567, an error
message will be printed, but the calls in the body of the if statement
will use the nonsense value, reading data from an invalid location.
It seems that there's another bug lurking in this code.
If we try to set voice to default, spk_set_num_var returns -ERESTART.
In this case, we shouldn't use value at all when setting the pitch and volume.
"value" is meaningless, regardless of what it contains.
We should use the value of the default voice as the index instead.  So
the following should be correct, and you can ignore what I suggested earlier.

if (param->var_id == VOICE && (ret == 0 || ret == -ERESTART)) {
	if (ret == -ERESTART)
		value = param->data.u.n.default_val;
	spk_reset_default_value("pitch", synth->default_pitch,
		value);
	spk_reset_default_value("vol", synth->default_vol,
		value);
}

-- Chris

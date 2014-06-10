Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaFJPjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:39:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57054 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFJPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140610143344.GA15699@redhat.com>
References: <20140606193128.CB477660FB4@gitolite.kernel.org>
	<20140610143344.GA15699@redhat.com>
Date: Tue, 10 Jun 2014 08:39:40 -0700
X-Google-Sender-Auth: KMd1t1D87ln9hH5ZVZZsICIhFH8
Message-ID: <CAD=FV=Wx2kuEHSebDQcrZs19o+7OAVo_WNNROoTwEkFc6xpqzQ@mail.gmail.com>
Subject: Re: i2c: ChromeOS EC tunnel driver
From: Doug Anderson <dianders@chromium.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Tue, Jun 10, 2014 at 7:33 AM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Jun 06, 2014 at 07:31:28PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=9d230c9e4f4e67cb1c1cb9e0f6142da16b0f2796
>  > Commit:     9d230c9e4f4e67cb1c1cb9e0f6142da16b0f2796
>  > Parent:     5271db29d7199fe0ffb303ca4bbbb1485bba28c3
>  > Refname:    refs/heads/next
>  > Author:     Doug Anderson <dianders@chromium.org>
>  > AuthorDate: Wed Apr 30 10:44:09 2014 -0700
>  > Committer:  Lee Jones <lee.jones@linaro.org>
>  > CommitDate: Tue Jun 3 08:11:49 2014 +0100
>
>  > +static int ec_i2c_construct_message(u8 *buf, const struct i2c_msg i2c_msgs[],
>  > +                                int num, u16 bus_num)
>  > +{
>  > +    struct ec_params_i2c_passthru *params;
>  > +    u8 *out_data;
>  > +    int i;
>  > +
>  > +    out_data = buf + sizeof(struct ec_params_i2c_passthru) +
>  > +               num * sizeof(struct ec_params_i2c_passthru_msg);
>  > +
>  > +    params = (struct ec_params_i2c_passthru *)buf;
>  > +    params->port = bus_num;
>  > +    params->num_msgs = num;
>  > +    for (i = 0; i < num; i++) {
>  > +            const struct i2c_msg *i2c_msg = &i2c_msgs[i];
>  > +            struct ec_params_i2c_passthru_msg *msg = &params->msg[i];
>  > +
>  > +            msg->len = i2c_msg->len;
>  > +            msg->addr_flags = i2c_msg->addr;
>  > +
>  > +            if (i2c_msg->flags & I2C_M_TEN)
>  > +                    msg->addr_flags |= EC_I2C_FLAG_10BIT;
>
> This is a fun bug. EC_I2C_FLAG_10BIT is 1<<16, but msg->addr_flags is only a uint16.

Good catch.  Luckily we have no actual 10-bit devices on the other
end, but it sure makes this bit of the tunnel pretty stupid.

The correct fix is to fix the master 'ec_commands.h' in the ChromeOS
EC project, then pull the change over to the kernel.  I've filed a bug
against our EC team at http://crbug.com/382944

-Doug

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3KODnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:43:01 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42985 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3KODmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:42:54 -0500
MIME-Version: 1.0
In-Reply-To: <528097A3.9040908@cn.fujitsu.com>
References: <1383300583-6953-1-git-send-email-duanj.fnst@cn.fujitsu.com>
	<CAPgLHd_p+LJmBX6FCy1+mF3VTHkBoPa83SNXciqb28pa3QE7TA@mail.gmail.com>
	<528097A3.9040908@cn.fujitsu.com>
Date: Fri, 15 Nov 2013 11:42:52 +0800
Message-ID: <CAPgLHd-3mrt_NpSz4dgXg_jJ0Lopm7rzWVAE_NLnyy1xtutPOw@mail.gmail.com>
Subject: Re: [PATCH] drivers: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
From: Wei Yongjun <weiyj.lk@gmail.com>
To: duanj.fnst@cn.fujitsu.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 04:38 PM, Duan Jiong wrote:
> äºŽ 2013å¹´11æœˆ11æ—¥ 15:43, Wei Yongjun å†™é“:
>> On 11/01/2013 06:09 PM, Duan Jiong wrote:
>>> This patch fixes coccinelle error regarding usage of IS_ERR and
>>> PTR_ERR instead of PTR_ERR_OR_ZERO.
>>>
>>> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
>>> ---
>>>  drivers/misc/carma/carma-fpga.c | 5 +----
>>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
>>> index 08b18f3..9a32e98 100644
>>> --- a/drivers/misc/carma/carma-fpga.c
>>> +++ b/drivers/misc/carma/carma-fpga.c
>>> @@ -956,10 +956,7 @@ static int data_debugfs_init(struct fpga_device *priv)
>>>  {
>>>  	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
>>>  					      &data_debug_fops);
>>> -	if (IS_ERR(priv->dbg_entry))
>>> -		return PTR_ERR(priv->dbg_entry);
>>> -
>>> -	return 0;
>>> +	return PTR_ERR_OR_ZERO(priv->dbg_entry);
>>>  }
>> Those code has make sure that CONFIG_DEBUG_FS is enabled, so
>> debugfs_create_file() never return PTR_ERR(), only NULL will
>> be returned when error occurs.
>>
>>
> You can see the definition about PTR_ERR_OR_ZERO in include/linux/err.h,
> it is merely used to simplify the code.

I means that the orig code has bug. You should fix the bug, not only do
some cleanup like this.

Also, the module name should be 'carma-fpga', not 'drivers'. You should send
something like this:

[PATCH] carma-fpga: fix the return value check in data_debugfs_init()

In case of error, the function debugfs_create_file() returns NULL
pointer not ERR_PTR() if CONFIG_DEBUG_FS is enabled. The IS_ERR()
test in the return value check should be replaced with NULL test.

...

-       if (IS_ERR(priv->dbg_entry))
-               return PTR_ERR(priv->dbg_entry);
+       if (!priv->dbg_entry)
+               return -ENOMEM;
...




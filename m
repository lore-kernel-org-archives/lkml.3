Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3KDCHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 21:07:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:3882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3KDCHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 21:07:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384165785"
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Topic: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Index: AQHO1t8Uf2o3S/2AC0Kjuan0TdIQzZoTypyAgACJ85A=
Date: Mon, 4 Nov 2013 02:07:32 +0000
Message-ID: <FA47D36D6EC9FE4CB463299737C09B9901B6467C@SHSMSX102.ccr.corp.intel.com>
References: <1383346094.2702.16.camel@wxm-ubuntu>
 <5276FBB5.1020506@samsung.com>
In-Reply-To: <5276FBB5.1020506@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA4286G1008850

Dear Choi

-----Original Message-----
From: Chanwoo Choi [mailto:cw00.choi@samsung.com] 
Sent: Monday, November 04, 2013 9:43 AM
To: Wang, Xiaoming
Cc: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org; Liu, Chuansheng; Zhang, Dongxing
Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning in unregister flow

Hi Wang,

>  drivers/extcon/extcon-class.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c 
> b/drivers/extcon/extcon-class.c index 148382f..48f4669 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -794,6 +794,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  		return;
>  	}
>  
> +	device_unregister(edev->dev);
> +
>  	if (edev->mutually_exclusive && edev->max_supported) {
>  		for (index = 0; edev->mutually_exclusive[index];
>  				index++)
> @@ -814,7 +816,6 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  	if (switch_class)
>  		class_compat_remove_link(switch_class, edev->dev, NULL);  #endif
> -	device_unregister(edev->dev);
>  	put_device(edev->dev);
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> 

I think we could only apply following patch instead of moving the position of device_unregister().

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c index 148382f..ff27b19 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -805,10 +805,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
        for (index = 0; index < edev->max_supported; index++)
                kfree(edev->cables[index].attr_g.name);
 
-       if (edev->max_supported) {
-               kfree(edev->extcon_dev_type.groups);
+       if (edev->max_supported)
                kfree(edev->cables);
-       }
 
 #if defined(CONFIG_ANDROID)
        if (switch_class)

Thanks,
Chanwoo Choi

	I don't agree with you.
	Why do not you want moving the position of device_unregister()?
	It will cause the memory leak if has not kfree edev->extcon_dev_type.groups as your patch do firstly. And if you think kfree edev->extcon_dev_type.groups is meaningless well then kfree edev->extcon_dev_type.groups in function exton_dev_register (line 756)also should be removed I think. What do you think?

Thanks
Xiaoming.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

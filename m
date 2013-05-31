Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3EaRAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:00:38 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:62321 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3EaRAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:00:30 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 13:00:30 EDT
X-AuditID: cbfec37b-b7f306d0000047de-3d-51a8d4d31573
From: Shuah Khan <shuah.kh@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] drivers/rtc/class: Convert from Legacy pm ops to dev_pm_ops
Thread-topic: [PATCH] drivers/rtc/class: Convert from Legacy pm ops to
 dev_pm_ops
Thread-index: AQHOXhe+S8DfKnd2wkGxcA64h662fw==
Date: Fri, 31 May 2013 16:50:25 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61565E2D@sisaex02sj>
References: <1370015872-3560-1-git-send-email-shuah.kh@samsung.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wn+6VKysCDV6fYbVYcvEqu8XlXXPY
	LB6veMtusb+zg9Hi608HB1aPnbPusnvsmXiSzWPxnpdMHtPn/WTy+LxJLoA1issmJTUnsyy1
	SN8ugSvjRNNp5oKtAhUv2ngaGB/wdjFyckgImEi8W9jBDGGLSVy4t56ti5GLQ0hgGaPEo575
	jBBOL5PEsZmTWSCc+YwSK/Y2s4C0sAmoS3x+vYMdxBYRUJVoufqYDcRmFpjNJHHjCReILSwQ
	IHHxzHlmiJpgiV2/u9kgbD2J2+f6wOawAPW+XL2DFcTmFbCXaHz7FiwuJOAssfr/BCYQmxHo
	vO+n1jBBzBeXaG69yQJxtoDEkj3noV4QlXj5+B/QHA4gW1Fi+2oriHI9iY9/bjNC2NoST95d
	gFolKPFj8j2WCYxis5BMnYWkZRaSlllIWhYwsqxiFCstTi4oTkpPrTDSK07MLS7NS9dLzs/d
	xAiJvOodjHe/2hxiFOBgVOLhNVixIlCINbGsuDL3EKMEB7OSCG/+HKAQb0piZVVqUX58UWlO
	avEhRiYOTqkGRpF5Gob/3FPe1jXYvZnPK6hQMmX1L62ANymSqbsrJtTLrJj7LX7VrqxDIZ5u
	5fIJOhy+hk8/v3t1x6Y5uOHzn29WAglGYvIt2/WnbQucrWtbPnHTgzDv86Wb/Y46W13n7bNs
	LWk9duNC4oF9v1YknSgXPubpbty9oTD676sGjp/eB2sP9Ik+VWIpzkg01GIuKk4EAGDXYIma	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 09:58 AM, Shuah Khan wrote:
> Convert drivers/rtc/class to use dev_pm_ops for power management and
> remove Legacy PM ops hooks. With this change, rtc class registers
> suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
> class->suspend/resume. When __device_suspend() runs call-backs, it will
> find class->pm ops for the rtc class.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/rtc/class.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 6638540..21d83ec 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -135,9 +135,9 @@ static int rtc_resume(struct device *dev)
>   	return 0;
>   }
>
> +static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
>   #else
> -#define rtc_suspend	NULL
> -#define rtc_resume	NULL
> +#define rtc_class_dev_pm_ops	NULL
>   #endif
>
>
> @@ -336,8 +336,7 @@ static int __init rtc_init(void)
>   		pr_err("couldn't create class\n");
>   		return PTR_ERR(rtc_class);
>   	}
> -	rtc_class->suspend = rtc_suspend;
> -	rtc_class->resume = rtc_resume;
> +	rtc_class->pm = &rtc_class_dev_pm_ops;
>   	rtc_dev_init();
>   	rtc_sysfs_init(rtc_class);
>   	return 0;
>

oops. I noticed a build warning rtc_suspend()

drivers/rtc/class.c:138:8: warning: initialization from incompatible 
pointer type [enabled by default]
drivers/rtc/class.c:138:8: warning: (near initialization for 
‘rtc_class_dev_pm_ops.suspend’) [enabled by default]


Please ignore this version. I will re-send v2 with the correct one. I 
missed removing the extra pm_message_t mesg on rtc_suspend().

-- Shuah
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

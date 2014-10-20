Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaJTGja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:39:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3191 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbaJTGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:39:28 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 19 Oct 2014 23:39:23 -0700
Subject: RE: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Topic: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Index: Ac/sIJbTXQKvxjX5QRq/D/vomZ1YNwAD4nzA
Message-ID: <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com>
In-Reply-To: <20141020044340.GA9589@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-19_03:2014-10-17,2014-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410200073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K6dac1022584

Greg,

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: 2014Äê10ÔÂ20ÈÕ 12:44
To: Neil Zhang
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug

On Mon, Oct 20, 2014 at 11:29:08AM +0800, Neil Zhang wrote:
> The current per-cpu offline info won't be updated if it is hotplugged 
> in/out by a kernel governer.
> Let's update it via cpu notifier.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/base/cpu.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c index 
> 006b1bc..9d61824 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -418,10 +418,35 @@ static void __init 
> cpu_dev_register_generic(void)  #endif  }
>  
> +static int device_hotplug_notifier(struct notifier_block *nfb,
> +				      unsigned long action, void *hcpu) {
> +	unsigned int cpu = (unsigned long)hcpu;
> +	struct device *dev = get_cpu_device(cpu);
> +	int ret;
> +
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_ONLINE:
> +		dev->offline = false;
> +		ret = NOTIFY_OK;
> +		break;
> +	case CPU_DYING:
> +		dev->offline = true;
> +		ret = NOTIFY_OK;
> +		break;
> +	default:
> +		ret = NOTIFY_DONE;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  void __init cpu_dev_init(void)
>  {
>  	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
>  		panic("Failed to register CPU subsystem");
>  
>  	cpu_dev_register_generic();
> +	cpu_notifier(device_hotplug_notifier, 0);
>  }

How much noise is this going to cause on a big/little system that constantly hot unplug/plugs processors all of the time?

Can you explain more what kind of noise will be introduced on a big/little system?
As I know IKS on arm will use cpu_suspend way to power down a core.
But I don't know well about other architectures.
Please give your suggestions.
Thanks!

greg k-h

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501Ab3E2Jso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:48:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44087 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab3E2Jsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:48:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,763,1363132800"; 
   d="scan'208";a="26601047"
Message-ID: <51A5CEF9.3050802@citrix.com>
Date: Wed, 29 May 2013 10:48:41 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: John Stultz <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when the
 system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com> <1369765368-10823-3-git-send-email-david.vrabel@citrix.com> <51A5CCDB02000078000D9798@nat28.tlf.novell.com>
In-Reply-To: <51A5CCDB02000078000D9798@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/13 08:39, Jan Beulich wrote:
>>>> On 28.05.13 at 20:22, David Vrabel <david.vrabel@citrix.com> wrote:
>> +static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
>> +				   void *priv)
>> +{
>> +	static struct timespec last, next;
>> +	struct timespec now;
>> +	struct timekeeper *tk = priv;
>> +	struct xen_platform_op op;
>> +	int ret;
>> +
>> +	/*
>> +	 * Set the Xen wallclock from Linux system time.
>> +	 *
>> +	 * dom0 hasn't historically maintained a very accurate
>> +	 * wallclock so guests don't expect it. We can therefore
>> +	 * reduce the number of expensive hypercalls by only updating
>> +	 * the wallclock every 0.5 s.
>> +	 */
>> +
>> +	now.tv_sec = tk->xtime_sec;
>> +	now.tv_nsec = tk->xtime_nsec >> tk->shift;
>> +
>> +	if (timespec_compare(&now, &last) > 0
>> +	    && timespec_compare(&now, &next) < 0)
> 
> Is this really working the first time through (when both last and
> next are still all zeros)?

Yes. The first time through we want to set the wallclock and this test
is always false when last == next.

David

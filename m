Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3F1Pt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:49:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15930 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1Pt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:49:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="32487977"
Message-ID: <51CDB0A1.6080409@citrix.com>
Date: Fri, 28 Jun 2013 16:49:53 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen wallclock
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-6-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/13 16:38, Thomas Gleixner wrote:
> On Thu, 27 Jun 2013, David Vrabel wrote:
> 
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Adjustments to Xen's persistent clock via update_persistent_clock()
>> don't actually persist, as the Xen wallclock is a software only clock
>> and modifications to it do not modify the underlying CMOS RTC.
>>
>> The x86_platform.set_wallclock hook can be used to keep the hardware
>> RTC synchronized (as on bare metal).  Because the Xen wallclock is now
>> kept synchronized by pvclock_gtod notifier, xen_set_wallclock() need
>> not do this and dom0 can simply use the native implementation.
> 
> I can understand that part, but ...
>  
>>  static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long was_set,
>>  				   void *priv)
>>  {
>> +	static struct timespec next;
>>  	struct timespec now;
>>  	struct xen_platform_op op;
>>  
>> -	if (!was_set)
>> -		return NOTIFY_OK;
>> -
>>  	now = __current_kernel_time();
>>  
>> +	if (!was_set && timespec_compare(&now, &next) < 0)
>> +		return NOTIFY_OK;
>> +
>>  	op.cmd = XENPF_settime;
>>  	op.u.settime.secs = now.tv_sec;
>>  	op.u.settime.nsecs = now.tv_nsec;
>>  	op.u.settime.system_time = xen_clocksource_read();
>>  
>>  	(void)HYPERVISOR_dom0_op(&op);
>> +
>> +	/*
>> +	 * Don't update the wallclock for another 11 minutes. This is
>> +	 * the same period as the sync_cmos_clock() work.
>> +	 */
>> +	next = now;
>> +	next.tv_sec += 11*60;
>> +
> 
> How is this related to the changelog? /me is confused .....

Before:

Xen wallclock set when time is stepped.
Xen wallclock set every 11 minutes (by sync_cmos_clock()).
Hardware RTC never set.

After:

Xen wallclock set when time is stepped.
Xen wallclock set every 11 minutes (in pvclock gtod notifier).
Hardware RTC set every 11 minutes (by sync_cmos_clock()).

I'll update the changelog to be more descriptive:

  Adjustments to Xen's persistent clock via update_persistent_clock()
  don't actually persist, as the Xen wallclock is a software only clock
  and modifications to it do not modify the underlying CMOS RTC.

  The x86_platform.set_wallclock hook can be used to keep the hardware
  RTC synchronized (as on bare metal).  If (in dom0) we make the Xen
  wallclock periodically synchronized by the pvclock_gtod notifier, the
  set_wallclock hook need not update the Xen wallclock and the native
  implementation can be used.

Is that better?

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3HUKof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:44:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3HUKoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:44:34 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1377076513.31937.22.camel@hastur.hellion.org.uk>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com> <1376425904.9273.25.camel@hastur.hellion.org.uk> <20130813205332.GA10243@phenom.dumpdata.com> <1376427570.9273.39.camel@hastur.hellion.org.uk> <1376432405.9273.54.camel@hastur.hellion.org.uk> <20130814001050.GA10492@phenom.dumpdata.com> <1376464556.9273.75.camel@hastur.hellion.org.uk> <20130814124647.GD10764@phenom.dumpdata.com> <1376577638.9273.188.camel@hastur.hellion.org.uk> <20130820193507.GI12037@phenom.dumpdata.com> <1377076513.31937.22.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it also work on HVM guests.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 21 Aug 2013 06:44:24 -0400
To: Ian Campbell <ian.campbell@citrix.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Message-ID: <9a4bcff8-932e-4f32-b64f-469d174e82b3@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <ian.campbell@citrix.com> wrote:
>On Tue, 2013-08-20 at 15:35 -0400, Konrad Rzeszutek Wilk wrote:
>>  void xen_raw_console_write(const char *str)
>>  {
>> -	dom0_write_console(0, str, strlen(str));
>> +	ssize_t len = strlen(str);
>> +	int rc = 0;
>> +
>> +	if (xen_domain()) {
>> +		rc = dom0_write_console(0, str, len);
>> +		if (rc != len && xen_hvm_domain()) /* -ENOSYS */
>
>If you want to catch ENOSYS then I suggest doing so explicitly, rather
>that relying on len != -ENOSYS.
>
>> +			goto outb_print;
>
>How about reversing this into
>	if (rc == len) return;
>	if (rc != -ENOSYS) panic(...) /* yes, this won't get far... *.
>
>Then fall through to the following block as a plain if not an else if.
>Maybe with a xen_hvm_domain && added.
>
>That avoids the yucky goto I think.
>
>> +	} else if (xen_cpuid_base()) {
>> +		int i;
>> +outb_print:
>> +		for (i = 0; i < len; i++)
>> +			outb(str[i], 0xe9);
>> +	}
>>  }
>>  
>>  void xen_raw_printk(const char *fmt, ...)

B/c the function  dom0_write_console never returns negative values.  Instead it converts it to a zero return value. Perhaps it can return negative values -  will have to look. 

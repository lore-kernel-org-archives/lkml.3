Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab3HGVKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:10:33 -0400
Received: from crispin.apple.com ([17.151.62.50]:62796 "EHLO
	mail-out.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab3HGVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:10:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-AuditID: 11807153-b7fd26d000007d21-29-5202b7c4f0a9
Subject: Re: [edk2] Corrupted EFI region
From: Andrew Fish <afish@apple.com>
In-reply-to: <20130807201908.GG2515@console-pimps.org>
Date: Wed, 07 Aug 2013 14:10:28 -0700
Cc: edk2-devel@lists.sourceforge.net, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Message-id: <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
References: <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
To: Matt Fleming <matt@console-pimps.org>
X-Mailer: Apple Mail (2.1508)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsUieE6oQffIdqYggzv/zC0mrpzMbPH3z39m
	i1UHOlgtlh3bwWLR9vAWo8XlXXPYLL5dncbkwO5xpvENo8fmFVoeuxd8ZvJ4v+8qm8fnTXIB
	rFFcNimpOZllqUX6dglcGUePnGQs2CJWMf3be7YGxgeCXYycHBICJhLX371jh7DFJC7cW8/W
	xcjFISSwiEli2bu7rCAJZgEtiRv/XjKB2LwCehJL/81hBLGFBTQkFt35xgxiswkoS6yY/wFs
	EKeAmcTHyQ9Yuhg5OFgEVCSe7ACbySxwnVHi2Y4fbBAztSWWLXzNDDHTRuLerhXMEIubmSXe
	NtwFS4gIaErMmb2MFWSQhICsxM7fSRMY+WchOWkWkpNmIRm7gJF5FaNAUWpOYqWxXmJBQU6q
	XnJ+7iZGUAA3FAbvYPyzzOoQowAHoxIP74MgpiAh1sSy4srcQ4wSHMxKIrwXi4FCvCmJlVWp
	RfnxRaU5qcWHGKU5WJTEeSM2AKUE0hNLUrNTUwtSi2CyTBycUg2MDed7Y8LtWy/41hhwvvr2
	ZDP3m/j/e3Xehuz+t+/a0nPlYf57jdn6JNwWbBfZvqb7ocmJNVwiSZxNP1evOhlU0OazK2b3
	lHnq91hmBfhfWLpL6B73payZwR4fd/3ySd/yhO/kgey4GS8vKVV8rXNoCpST7lb9fnuuBqum
	woa9B3b9ePtw6yWOBUosxRmJhlrMRcWJAIFS2MFcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 1:19 PM, Matt Fleming <matt@console-pimps.org> wrote:

> [ Readding Matthew Garrett to the Cc list, seeing as we both got removed
>  for some unknown reason ]
> 
> On Wed, 07 Aug, at 10:23:56AM, Andrew Fish wrote:
> 
>> OK so I think I need some Cliff Notes here to help me understand what
>> is going on...
>> 
>> type 4 is EfiBootServicesData and attr 0x0f is cache attributes with
>> no request for a runtime mapping. This is not runtime memory so to the
>> OS loader it is just memory EFI has used that will get freed back to
>> the OS after ExitBootServices(), along with EfiBootServicesCode,
>> EfiLoaderCode, and EfiLoaderData. The EfiLoaderCode and EfiLoaderData
>> also get freed back to the OS and they just exist for the convenience
>> of the OS loader. 
>> 
>> So I can't figure out why this maters? Given:
> 
> We've seen a bunch of systems that make calls into EfiBootServicesCode
> after ExitBootServices(). There were some Apple machines in that list,
> though I don't have the details but Matthew should.
> 

I think there was some very old EDK (pre edk2) bug that caused some SMM code to grab EfiBootServicesCode at runtime. In some older Apple machines I remember working with Mathew to track down a bug in the WiFi driver not shutting down its DMA at ExitBootServices() time. I'm guessing in general that pre-Windows 8 systems may tend to be buggy. 

> So we map these regions unconditionally and in their original state,
> otherwise the firmware will generate fatal page faults when trying to
> access those memory regions.
> 

Well the issue I see is I don't think OS X or Windows are doing this. So I'm guessing there is some unique thing beings done on the Linux side and we don't have good tests to catch bugs in the EFI implementations. If the Linux loader hides the bugs and we don't hit them with other operating systems they are never going to get fixed. It would be good if we could track down some of these issues and make a request for some tests that can help catch these issues. The tests would be part of UEFI.org, but since some of us play in both worlds we can forward the known issues to the UEFI test work group. 

Is it possible to have a switch to turn off the not required behavior (hiding EFI implementation bugs) so that bad platforms could be detected? This would be a good thing to try on platforms at the upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI Forum, so the bad behavior can be detected and the vendors can fix the issue. 

Thanks,

Andrew Fish

PS Also maybe it would be possible to key this work around behavior on the EFI/UEFI version. So for example no work-around after UEFI v2.3.1?

> -- 
> Matt Fleming, Intel Open Source Technology Center


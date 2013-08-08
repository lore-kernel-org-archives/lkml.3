Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965922Ab3HHQKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:10:21 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64820 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab3HHQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <CABTtd+0XfYwv9MxkvxnMRQ+c6UHv6gbnOyqAmr__eMuRta36gQ@mail.gmail.com>
References: <CAEtk5gcFrnbgGNeAU45-6TKR=m6=9QorFj_j_RX+ufGBfs5TuQ@mail.gmail.com>
	<CABTtd+0XfYwv9MxkvxnMRQ+c6UHv6gbnOyqAmr__eMuRta36gQ@mail.gmail.com>
Date: Thu, 8 Aug 2013 09:10:18 -0700
Message-ID: <CAMbhsRQ4ac=+QnQEJASYVCH33Nyssr16nU+hdP6quLT_s6iXRg@mail.gmail.com>
Subject: Re: Linux apanic mechanism and difference from newer
 ram_console/persistent_ram mechanism
From: Colin Cross <ccross@google.com>
To: Yuva Raj <yuvaeasy@gmail.com>
Cc: Vijay <thelonejoker@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 4:50 AM, Yuva Raj <yuvaeasy@gmail.com> wrote:
> On Thu, Aug 8, 2013 at 3:03 PM, Vijay <thelonejoker@gmail.com> wrote:
>>
>> Hello,
>>
>>
>> I am new to the Kernel-Mailing list. I am not subscribed at the moment
>> and would really appreciate it, if I can be CC'd in the
>> reply/responses for my question.
>>
>> I am studying the different logging mechanisms on Linux in case of a
>> Kernel panic (OOPS). So far from  my search on the web, I have been
>> able to derive the following information, please correct me if wrong:
>>
>> - apanic was an old mechanism of getting the job done.
>> - ram_console/persistent_ram is a new mechanism.
>>
>> Could someone enlighten me about the following in this regard ?
>>
>> - What was the old apanic mechanism, at a high-level how did this work ?
>
> It is a mechanism used by Android for kernel message logging. It
> writes the log message into some specific offset in mtd partition . On
> the next boot if the panic magic presents in the mtd partition, then
> the panic message  will be displayed on the console. The driver module
> exports a  file named "apanic" to the "debugfs". The debugfs can be
> mounted on some directory using the command, " mount -t debugfs none
> /sys/kernel/debug" which requires debugfs support needs to be enabled
> in linux kernel.
> For more information on this go through the source code in link below.
>
> https://android.googlesource.com/kernel/msm.git/+/android-msm-2.6.35/drivers/misc/apanic.c
>>
>>
>> - Why was the apanic mechanism deprecated, in favor of the
>> ram_console/persistent_ram mechanism ?
>>
> This apanic driver is not part of a linux kernel. It is specific to
> android. It is deprecated in latest version of android. The reason
> could be writing into mtd partition may not be a good idea when kernel
> opps happens. Since the nand_write is slow as well as has limited
> write cycles. This is just my opinion. But i am not sure of the actual
> reason .

The reason it was deprecated (and the main difference between
ram_console/persistent_ram/pstore_ram) is that apanic only runs on
panic, and then writes the logs to flash.  It doesn't log anything for
unexpected resets like watchdogs and external resets.

I believe the same functionality as apanic now exists in pstore.

>>
>> - What advantages does the new ram_console/persistent_ram mechanism
>> bring to the table.
>>
> It is also a logging mechanism used by android for logging console
> messages. Here the logging messages goes into RAM area. In case of
> persistent_ram , the log messages goes to persistent memory area
> (which will be retained ) of RAM. This driver module creates a file
> named "last_kmsg" in the proc directory. The logged message can be
> read in next boot if the kernel oops and stops booting. For more
> information go through the source code given in the below link.
>
> https://android.googlesource.com/kernel/common.git/+/android-3.4/drivers/staging/android/ram_console.c
>>
>> - In what way is the ram_console/persistent_ram functionally different
>>
>> from the old apanic approach ?
>>
> The former logs into ram and the later logs into mtd.

The other big differnece is that apanic only logs on panic.
ram_console writes the logs as they are logged, so any reboot
(watchdog, external reset, panic, normal reboot) has full logs up to
the reset.  Both functionalities are supported in pstore now.

>> I am just looking for pointers and high level answers, in some sense a
>> direction which I can take to research the mechanisms further. I would
>> appreciate any relevant information in this regard.
>>
>> Thanks
>
>
>  This mailing list is about latest linux kernel  features and patch
> works. So it is good to post these type of questions on
> http://kernelnewbies.org/  or on  google android development
> discussion page.
>
>  Yuvaraj.A
>
> On Thu, Aug 8, 2013 at 11:33 AM, Vijay <thelonejoker@gmail.com> wrote:
>> Hello,
>>
>> I am new to the Kernel-Mailing list. I am not subscribed at the moment
>> and would really appreciate it, if I can be CC'd in the
>> reply/responses for my question.
>>
>> I am studying the different logging mechanisms on Linux in case of a
>> Kernel panic (OOPS). So far from  my search on the web, I have been
>> able to derive the following information, please correct me if wrong:
>>
>> - apanic was an old mechanism of getting the job done.
>> - ram_console/persistent_ram is a new mechanism.
>>
>> Could someone enlighten me about the following in this regard ?
>>
>> - What was the old apanic mechanism, at a high-level how did this work ?
>>
>> - Why was the apanic mechanism deprecated, in favor of the
>> ram_console/persistent_ram mechanism ?
>>
>> - What advantages does the new ram_console/persistent_ram mechinsm
>> bring to the table.
>>
>> - In what way is the ram_console/persistent_ram functionally different
>> from the old apanic approach ?
>>
>> I am just looking for pointers and high level answers, in some sense a
>> direction which I can take to research the mechanisms further. I would
>> appreciate any relevant information in this regard.
>>
>> Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3BAQzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:55:10 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50071 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab3BAQzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:55:07 -0500
Message-ID: <510BF365.2010609@arm.com>
Date: Fri, 01 Feb 2013 16:55:01 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/2] staging: android: ashmem: fix ashmem pin/unpin interface
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com> <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com> <20130201161836.GA29021@kroah.com>
In-Reply-To: <20130201161836.GA29021@kroah.com>
X-OriginalArrivalTime: 01 Feb 2013 16:55:01.0834 (UTC) FILETIME=[E04CA2A0:01CE009C]
X-MC-Unique: 113020116550416301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 01/02/13 16:18, Greg KH wrote:
> On Fri, Feb 01, 2013 at 04:08:00PM +0000, Serban Constantinescu wrote:
>> The values exchanged between kernel and userspace through struct
>> ashmem_pin should be of type size_t. This change won't affect the
>> existing interface but will stand as the basis of 64bit compat layer.
>
> How do you define size_t with a 64bit kernel and a 32bit userspace
> properly?  Doesn't this change open up a bunch of problems?

The current ashmem pin/unpin kernel interface uses __u32 to specify the 
memory region and length in bytes. However these values  should be of 
type size_t so that they are able to represent the whole range of 
possible values when compiled for a 64bit platform.

Android API uses ashmem driver through libcutils, from where I attach 
the following snippet:

<aosp>/system/core/libcutils/ashmem-dev.c

   75 int ashmem_pin_region(int fd, size_t offset, size_t len)
   76 {
   77         struct ashmem_pin pin = { offset, len };
   78         return ioctl(fd, ASHMEM_PIN, &pin);
   79 }

The kernel changes inline with the userspace usage and do not affect 
existing 32bit Android (we have exported the new kernel header, rebuilt 
and tested the interface with success).

However this change will affect any 64bit userspace using the current 
faulty interface, but there is none that we know of.

Thanks,
Serban Constantinescu
`




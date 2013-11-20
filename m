Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3KTJ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:29:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3KTJ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:29:49 -0500
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com> <52740A3A.70202@nod.at>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@gmail.com>,
        Madper Xie <cxie@redhat.com>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?utf-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
In-reply-to: <52740A3A.70202@nod.at>
Date: Wed, 20 Nov 2013 17:29:12 +0800
Message-ID: <87r4abmnfb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard@nod.at writes:

> Am 01.11.2013 20:22, schrieb Seiji Aguchi:
>>>
>>> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
>>> more than this.
>> 
>> I was worried that the part and count could be more than 100.
>> If it happens, the id may not be unique...
>> 
>> But, currently, size of nvram storage is limited, so it is a corner case.
>> I respect your opinion.
>
> What about feeding the bytes of all three integers into a
> non-cryptographic hash function?

Then will lost the sequence of our log. We will get lots of entries like
"dmesg-efi-`unique but meaningless number here`" in pstore fs. Who will
know which file is the latest record?
A possible way is sort them by created time. But pstore splits large
messages into many parts. So they will have the same created-time. Like
the following case:
[root@dhcp-13-41 ~]# ls -rtl /dev/pstore/
total 0
-r--r--r--. 1 root root  930 Nov 15 08:42 dmesg-efi-9
-r--r--r--. 1 root root 1017 Nov 15 08:42 dmesg-efi-8
-r--r--r--. 1 root root  993 Nov 15 08:42 dmesg-efi-7
-r--r--r--. 1 root root  984 Nov 15 08:42 dmesg-efi-6
-r--r--r--. 1 root root 1008 Nov 15 08:42 dmesg-efi-5
-r--r--r--. 1 root root  909 Nov 15 08:42 dmesg-efi-10
-r--r--r--. 1 root root 1003 Nov 15 08:42 dmesg-efi-11
-r--r--r--. 1 root root  980 Nov 18 00:41 dmesg-efi-4
-r--r--r--. 1 root root  990 Nov 18 00:41 dmesg-efi-3
-r--r--r--. 1 root root  966 Nov 18 00:41 dmesg-efi-2
-r--r--r--. 1 root root 1010 Nov 18 00:41 dmesg-efi-1

or more intuitive:
ls /sys/firmware/efi/efivars/ | grep -i "dump" | cut -d'-' -f5 | sort |wc -l
103
ls /sys/firmware/efi/efivars/ | grep -i "dump" | cut -d'-' -f5 | sort |uniq |wc -l
26

So if we using a hashed unique number for uniqueness, we will lose the
sequence. We must sort them manually.

And another side, the combin of timestamp, count and part is unique. Why
we generate a unique number from a unique number?
if you think "making a string from three ints and then a parse it to a
int again" is odd, i'd like to use ((timestamp * 100 + part) * 100 +
count.

> Using this way you get a cheap unique id.
>
> Thanks,
> //richard


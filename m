Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaINSKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:10:00 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:44669 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaINSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:09:59 -0400
X-Yandex-Uniq: d652ca09-6c64-49f7-a071-fc0311e93fc9
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5415D9F1.4080605@yandex.ru>
Date: Sun, 14 Sep 2014 22:09:53 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>
CC: Michal Marek <mmarek@suse.cz>, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        Andrew Morton <akpm@linux-foundation.org>, ktkhai@parallels.com,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kbuild: Make targets names tree-wide unique on x86
References: <20140914100545.3745.23394.stgit@localhost> <20140914101821.3745.21235.stgit@localhost> <CAOFdcFP0gRDX66ius=VAN8xZZUeX9f93C7YwL52TrsJegTyy1g@mail.gmail.com>
In-Reply-To: <CAOFdcFP0gRDX66ius=VAN8xZZUeX9f93C7YwL52TrsJegTyy1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2014 19:57, Peter Foley wrote:
> On Sun, Sep 14, 2014 at 6:18 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
>> diff --git a/init/Makefile b/init/Makefile
>> index 7bc47ee..566a9ff 100644
>> --- a/init/Makefile
>> +++ b/init/Makefile
>> @@ -2,23 +2,28 @@
>>  # Makefile for the linux kernel.
>>  #
>>
>> -obj-y                          := main.o version.o mounts.o
>> +obj-y                          := main.o version.o do_mounts.o
>> +
>>  ifneq ($(CONFIG_BLK_DEV_INITRD),y)
>>  obj-y                          += noinitramfs.o
>>  else
>> -obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
>> +obj-y                          += initramfs.o do_mounts_initrd.o
>> +endif
>> +
>> +ifeq ($(CONFIG_BLK_DEV_RAM),y)
>> +obj-y                          += do_mounts_rd.o
>>  endif
>> +
>> +ifeq ($(CONFIG_BLK_DEV_MD),y)
>> +obj-y                          += do_mounts_md.o
>> +endif
>> +
>>  obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
>>
>>  ifneq ($(CONFIG_ARCH_INIT_TASK),y)
>>  obj-y                          += init_task.o
>>  endif
>>
>> -mounts-y                       := do_mounts.o
>> -mounts-$(CONFIG_BLK_DEV_RAM)   += do_mounts_rd.o
>> -mounts-$(CONFIG_BLK_DEV_INITRD)        += do_mounts_initrd.o
>> -mounts-$(CONFIG_BLK_DEV_MD)    += do_mounts_md.o
>> -
> 
> Can't you keep the obj-$(CONFIG_*) syntax?
> e.g.
> obj-$(CONFIG_BLK_DEV_RAM) += do_mounts_rd.o
> 

They are need only in CONFIG_XXX=y case. They contain stubs
which are not compiled in case of =m. Look at rd_load_image()
for example.

So, here I prevent compilation errors, and make them uncompilable
in =m case like it used to be before.

Kirill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbaDJTHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:07:18 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36392 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaDJTHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:07:15 -0400
Message-ID: <5346EBDF.2020801@mit.edu>
Date: Thu, 10 Apr 2014 12:07:11 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?UTF-8?B?S3Jpc3RpYW4gSMO4Zw==?= =?UTF-8?B?c2Jlcmc=?= 
	<krh@bitplanet.net>,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/6] shm: add memfd_create() syscall
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>	<1395256011-2423-4-git-send-email-dh.herrmann@gmail.com> <CALYGNiPnAVf+wSsdn4aO=89H_HqyjL_-vNHpZdop=Wchf7gTtw@mail.gmail.com>
In-Reply-To: <CALYGNiPnAVf+wSsdn4aO=89H_HqyjL_-vNHpZdop=Wchf7gTtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 06:38 AM, Konstantin Khlebnikov wrote:
> On Wed, Mar 19, 2014 at 11:06 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
>> that you can pass to mmap(). It explicitly allows sealing and
>> avoids any connection to user-visible mount-points. Thus, it's not
>> subject to quotas on mounted file-systems, but can be used like
>> malloc()'ed memory, but with a file-descriptor to it.
>>
>> memfd_create() does not create a front-FD, but instead returns the raw
>> shmem file, so calls like ftruncate() can be used. Also calls like fstat()
>> will return proper information and mark the file as regular file. Sealing
>> is explicitly supported on memfds.
>>
>> Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
>> subject to quotas and alike.
> 
> Instead of adding new syscall we can extend existing openat() a little
> bit more:
> 
> openat(AT_FDSHM, "name", O_TMPFILE | O_RDWR, 0666)

Please don't.  O_TMPFILE is a messy enough API, and the last thing we
need to do is to extend it.  If we want a fancy API for creating new
inodes with no corresponding dentry, let's create one.

Otherwise, let's just stick with a special-purpose API for these shm files.

--Andy

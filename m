Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbbAZOqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:46:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33797 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbAZOqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:46:37 -0500
Message-ID: <54C65346.5070504@gmail.com>
Date: Mon, 26 Jan 2015 15:46:30 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: mtk.manpages@gmail.com, David Herrmann <dh.herrmann@gmail.com>,
        Daniel Mack <daniel@zonque.org>, Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, "Theodore T'so" <tytso@mit.edu>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com> <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
In-Reply-To: <20150123160854.GA5210@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On 01/23/2015 05:08 PM, Greg Kroah-Hartman wrote:
> On Thu, Jan 22, 2015 at 09:49:00AM -0500, Austin S Hemmelgarn wrote:
>> While I agree that there should be a way for userspace to get the list of
>> supported operations, userspace apps will only actually care about that
>> once, when they begin talking to kdbus, because (ignoring the live kernel
>> patching that people have been working on recently) the list of supported
>> operations isn't going to change while the system is running.  While a u64
>> copy has relatively low overhead, it does have overhead, and that is very
>> significant when you consider part of the reason some people want kdbus is
>> for the performance gain.  Especially for those automotive applications that
>> have been mentioned which fire off thousands of messages during start-up,
>> every little bit of performance is significant.
> 
> A single u64 in a structure is not going to be measurable at all,
> processors just copy memory too fast these days for 4 extra bytes to be
> noticable.  

It depends on the definition of measurable, I suppose, but this statement
appears incorrect to me. In some cases (e.g., kdbus_msg_info) we're talking
about *two* u64 fields (kernel_gs, kernel_msg_flags) being used to pass back
sets of valid flags. That's 16 bytes, and it definitely makes a difference.
Simply running a loop that does a naive memcpy() in a tight user-space
loop (code below), I see the following for the execution of 1e9 loops:

    Including the two extra u64 fields: 3.2 sec
    Without the two extra u64 fields:   2.6 sec

On the same box, doing 1e9 calls to getppid() (i.e., pretty much the
simplest syscall, giving us a rough measure of the context switch) takes
68 seconds. In other words, the cost of copying those 16 bytes is about 1%
of the base context switch/syscall cost. I assume the costs of copying 
those 16 bytes across the kernel-user-space boundary would not be cheaper, 
but have not tested that. If my assumption is correct, then 1% seems a
significant figure to me in an API whose raison d'être is speed.

> So let's make this as easy as possible for userspace, making
> it simpler logic there, which is much more important than saving
> theoretical time in the kernel.

But this also missed the other part of the point. Copying these fields on
every operation, when in fact they are only needed once, clutters the API,
in my opinion. Good APIs are as simple as they can be to do their job. 
Redundancy is an enemy of simplicity. Simplest would have been a one time 
API that returns a structure containing all of the supported flags across 
the API. Alternatively, the traditional EINVAL approach is well understood,
and suffices.

Thanks,

Michael

=========

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct kdbus_msg_info {
    uint64_t offset;
    uint64_t msg_size;
    uint64_t return_flags;
};

struct kdbus_cmd_send {
        uint64_t size;
        uint64_t flags;
#if FIELDS >= 1
        uint64_t kernel_flags;
#endif
#if FIELDS >= 2
        uint64_t kernel_msg_flags;
#endif
        uint64_t return_flags;
        uint64_t msg_address;
        struct kdbus_msg_info reply;
        //struct kdbus_item items[0];
} __attribute__((aligned(8)));

int
main(int argc, char *argv[])
{
    long nloops, j;
    struct kdbus_cmd_send src, dst;
    memset(&dst, 0, sizeof(struct kdbus_cmd_send));

    printf("struct size: %zd\n", sizeof(struct kdbus_cmd_send));
    nloops = (argc > 1) ? atol(argv[1]) : 1000000000;

    for (j = 0; j < nloops; j++) {
        memcpy(&dst, &src, sizeof(struct kdbus_cmd_send));
    }

    exit(EXIT_SUCCESS);
}


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

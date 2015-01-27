Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbbA0SD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:03:57 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62765 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbbA0SDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:03:55 -0500
Message-ID: <54C7D300.8070208@gmail.com>
Date: Tue, 27 Jan 2015 19:03:44 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: mtk.manpages@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
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
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com>	<CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>	<54C10DDC.9000503@gmail.com>	<20150123160854.GA5210@kroah.com>	<54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
In-Reply-To: <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 01/27/2015 04:05 PM, David Herrmann wrote:
> Hi
> 
> On Mon, Jan 26, 2015 at 3:46 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hello Greg,
>>
>> On 01/23/2015 05:08 PM, Greg Kroah-Hartman wrote:
>>> On Thu, Jan 22, 2015 at 09:49:00AM -0500, Austin S Hemmelgarn wrote:
>>>> While I agree that there should be a way for userspace to get the list of
>>>> supported operations, userspace apps will only actually care about that
>>>> once, when they begin talking to kdbus, because (ignoring the live kernel
>>>> patching that people have been working on recently) the list of supported
>>>> operations isn't going to change while the system is running.  While a u64
>>>> copy has relatively low overhead, it does have overhead, and that is very
>>>> significant when you consider part of the reason some people want kdbus is
>>>> for the performance gain.  Especially for those automotive applications that
>>>> have been mentioned which fire off thousands of messages during start-up,
>>>> every little bit of performance is significant.
>>>
>>> A single u64 in a structure is not going to be measurable at all,
>>> processors just copy memory too fast these days for 4 extra bytes to be
>>> noticable.
>>
>> It depends on the definition of measurable, I suppose, but this statement
>> appears incorrect to me. In some cases (e.g., kdbus_msg_info) we're talking
>> about *two* u64 fields (kernel_gs, kernel_msg_flags) being used to pass back
>> sets of valid flags. That's 16 bytes, and it definitely makes a difference.
>> Simply running a loop that does a naive memcpy() in a tight user-space
>> loop (code below), I see the following for the execution of 1e9 loops:
>>
>>     Including the two extra u64 fields: 3.2 sec
>>     Without the two extra u64 fields:   2.6 sec
>>
>> On the same box, doing 1e9 calls to getppid() (i.e., pretty much the
>> simplest syscall, giving us a rough measure of the context switch) takes
>> 68 seconds. In other words, the cost of copying those 16 bytes is about 1%
>> of the base context switch/syscall cost. I assume the costs of copying
>> those 16 bytes across the kernel-user-space boundary would not be cheaper,
>> but have not tested that. If my assumption is correct, then 1% seems a
>> significant figure to me in an API whose raison d'être is speed.
> 
> I have no idea how this is related to any kdbus ioctl?
> 
> A 16byte copy does not affect the performance of kdbus message
> transactions in any way that matters.

I'm not sure if it's related/significant or not, since I'm ignorant
of the performance figures for kdbus. I just got curious when Greg
stated that the cost of copying would not be noticeable. (I got curious 
also about my assumption, and did an experiment with a dummy system call
that throws bytes across the fence into user space. The cost of an
extra 16 bytes (56 to 72 bytes) is about 3% of the base syscall/context 
switch cost.)

>>> So let's make this as easy as possible for userspace, making
>>> it simpler logic there, which is much more important than saving
>>> theoretical time in the kernel.
>>
>> But this also missed the other part of the point. Copying these fields on
>> every operation, when in fact they are only needed once, clutters the API,
>> in my opinion. Good APIs are as simple as they can be to do their job.
>> Redundancy is an enemy of simplicity. Simplest would have been a one time
>> API that returns a structure containing all of the supported flags across
>> the API. Alternatively, the traditional EINVAL approach is well understood,
>> and suffices.
> 
> We're going to drop "kernel_flags" in favor of a new
> KDBUS_FLAG_NEGOTIATE flag which asks the kernel to do feature
> negotiation for this ioctl and return the supported flags/items inline
> (overwriting the passed data). The ioctl will not be executed and will
> not affect the state of the FD.
> I hope this keeps the API simple.

Not sure I quite understand the details from your description, but I assume 
the it'll end up in the doc, and I'll try to take a look later.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

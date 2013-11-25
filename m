Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3KYVDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:03:49 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44510 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3KYVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131125200552.GA5826@mguzik.redhat.com>
References: <CAJusiZXq0CPHNvNCKCRp=XZ8UO9gFKVsU3cTEON5BCHDxrqFZQ@mail.gmail.com>
	<52939151.8030908@akamai.com>
	<CAJusiZWCrDovv_w29LeFA6m61CdWs4Ljxhwf_chNpNVGvmUKLA@mail.gmail.com>
	<20131125200552.GA5826@mguzik.redhat.com>
Date: Mon, 25 Nov 2013 13:03:46 -0800
Message-ID: <CAJusiZVjiH6P4cLZULrS4KWk8WUQUmG61zrJJNM5L_KzOYKh-Q@mail.gmail.com>
Subject: Re: disappearing listen()ed SO_REUSEPORT sockets across fork() when
 using epoll
From: Shawn Landden <shawnlandden@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 12:05 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
> On Mon, Nov 25, 2013 at 11:53:24AM -0800, Shawn Landden wrote:
>> On Mon, Nov 25, 2013 at 10:05 AM, Jason Baron <jbaron@akamai.com> wrote:
>> > On 11/22/2013 12:53 PM, Shawn Landden wrote:
>> >> Hello, when running the attached program on 3.12 child processes
>> >> are missing a socket fd opened, set with SO_REUSEPORT, listen()ed to,
>> >> and added to epoll_ctl().
>> >>
>> >> This is the output I get when pointing "wget http://localhost:5555/"
>> >> at the attached program:
>> >>
>> >> main PID 31591
>> >> PID 31634 started
>> >> PID 31634 accept()ed connection
>> >> PID 31635 started
>> >> PID 31636 started
>> >> PID 31635 accept() failed: Bad file descriptor
>> >> PID 31636 accept() failed: Bad file descriptor
>> >> PID 31634 accept()ed connection
>> >> PID 31634 accept()ed connection
>> >> PID 31634 accept()ed connection
>> >> PID 31634 accept()ed connection
>> >>
>> >>
>> >> While I would expect something like:
>> >>
>> >> main PID 31591
>> >> PID 31634 started
>> >> PID 31634 accept()ed connection
>> >> PID 31635 started
>> >> PID 31636 started
>> >> PID 31635 accept()ed connection
>> >> PID 31636 accept()ed connection
>> >>
>> >> -more new processes, but inversely proportional to number of listening processes
>> >> -accept() always returns successfully
>> >>
>> >>
>> >
>> > The 'close(sockfd);' looks to be racing with the accept() calls. Removing seems
>> > to get the result you are looking for.
>> Interesting. That works, but it shouldn't. The close() is operating in
>> the parent, so it shouldn't affect the child,
>> there is a leak here of process separation.
>>
>
> You fork, then close sockfd in the parent. Thus, the very first child
> can accept connectins just fine.
>
> Subsequent forks give you children without sockfd, thus accept fails.
> The first child continues to work just fine.
Now I feel like an idiot.



-- 

---
Shawn Landden
+1 360 389 3001 (SMS preferred)

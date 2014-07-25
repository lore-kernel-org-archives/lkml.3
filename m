Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbaGYUCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:02:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621AbaGYUCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:02:45 -0400
Message-ID: <53D2B7E2.5060200@redhat.com>
Date: Fri, 25 Jul 2014 21:02:42 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: Abhijith Das <adas@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Cluster-devel] [RFC] readdirplus implementations: xgetdents
 vs dirreadahead syscalls
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com> <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com> <20140725175257.GK17798@lenny.home.zabbo.net> <53D29D0C.2040606@redhat.com> <20140725182817.GL17798@lenny.home.zabbo.net>
In-Reply-To: <20140725182817.GL17798@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25/07/14 19:28, Zach Brown wrote:
> On Fri, Jul 25, 2014 at 07:08:12PM +0100, Steven Whitehouse wrote:
>> Hi,
>>
>> On 25/07/14 18:52, Zach Brown wrote:
[snip]
>>> Hmm.  Have you tried plumbing these read-ahead calls in under the normal
>>> getdents() syscalls?
>>>
>>> We don't have a filereadahead() syscall and yet we somehow manage to
>>> implement buffered file data read-ahead :).
>>>
>>> - z
>>>
>> Well I'm not sure thats entirely true... we have readahead() and we also
>> have fadvise(FADV_WILLNEED) for that.
> Sure, fair enough.  It would have been more precise to say that buffered
> file data readers see read-ahead without *having* to use a syscall.
>
>> doubt, but how would we tell getdents64() when we were going to read the
>> inodes, rather than just the file names?
> How does transparent file read-ahead know how far to read-ahead, if at
> all?
In the file readahead case it has some context, and thats stored in the 
struct file. Thats where the problem lies in this case, the struct file 
relates to the directory, and when we then call open, or stat or 
whatever on some file within that directory, we don't pass the 
directory's fd to that open call, so we don't have a context to use. We 
could possibly look through the open fds relating to the process that 
called open to see if the parent dir of the inode we are opening is in 
there, in order to find the context to figure out whether to do 
readahead or not, but...... its not very nice to say the least.

I'm very much in agreement that doing this automatically is best, but 
that only works when its possible to get a very good estimate of whether 
the readahead is needed or not. That is much easier for file data than 
it is for inodes in a directory. If someone can figure out how to get 
around this problem though, then that is certainly something we'd like 
to look at.

The problem gets even more tricky in case the user only wants, say, half 
of the inodes in the directory... how does the kernel know which half?

The idea here is really to give some idea of the kind of performance 
gains that we might see with the readahead vs xgetdents approaches, and 
by the sizes of the patches, the relative complexity of the implementations.

I think overall, the readahead approach is the more flexible... if I had 
a directory full of files I wanted to truncate for example, it would be 
possible to use the same readahead to pull in the inodes quickly and 
then issue the truncates to the pre-cached inodes. That is something 
that would not be possible using xgetdents. Whether thats useful for 
real world applications or not remains to be seen, but it does show that 
it can handle more potential use cases than xgetdents. Also the ability 
to only readahead an application specific subset of inodes is a useful 
feature.

There is certainly a discussion to be had about how to specify the 
inodes that are wanted. Using the directory position is a relatively 
easy way to do it, and works well when most of the inodes in a directory 
are wanted. Specifying the file names would work better when fewer 
inodes are wanted, but then if very few are required, is readahead 
likely to give much of a gain anyway?... so thats why we chose the 
approach that we did.

> How do the file systems that implement directory read-ahead today deal
> with this?
I don't know of one that does - or at least readahead of the directory 
info itself is one thing (which is relatively easy, and done by many 
file systems) its reading ahead the inodes within the directory which is 
more complex, and what we are talking about here.

> Just playing devil's advocate here:  It's not at all obvious that adding
> more interfaces is necessary to get directory read-ahead working, given
> our existing read-ahead implementations.
>
> - z
Thats perfectly ok - we hoped to generate some discussion and they are 
good questions,

Steve.


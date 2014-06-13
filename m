Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaFMPd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:33:59 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48087 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
Date: Fri, 13 Jun 2014 17:33:56 +0200
Message-ID: <CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jun 13, 2014 at 5:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 13, 2014 at 8:15 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Hi
>>
>> On Fri, Jun 13, 2014 at 5:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jun 13, 2014 at 3:36 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>>> Hi
>>>>
>>>> This is v3 of the File-Sealing and memfd_create() patches. You can find v1 with
>>>> a longer introduction at gmane:
>>>>   http://thread.gmane.org/gmane.comp.video.dri.devel/102241
>>>> An LWN article about memfd+sealing is available, too:
>>>>   https://lwn.net/Articles/593918/
>>>> v2 with some more discussions can be found here:
>>>>   http://thread.gmane.org/gmane.linux.kernel.mm/115713
>>>>
>>>> This series introduces two new APIs:
>>>>   memfd_create(): Think of this syscall as malloc() but it returns a
>>>>                   file-descriptor instead of a pointer. That file-descriptor is
>>>>                   backed by anon-memory and can be memory-mapped for access.
>>>>   sealing: The sealing API can be used to prevent a specific set of operations
>>>>            on a file-descriptor. You 'seal' the file and give thus the
>>>>            guarantee, that it cannot be modified in the specific ways.
>>>>
>>>> A short high-level introduction is also available here:
>>>>   http://dvdhrm.wordpress.com/2014/06/10/memfd_create2/
>>>
>>> Potentially silly question: is it guaranteed that mmapping and reading
>>> a SEAL_SHRINKed fd within size bounds will not SIGBUS?  If so, should
>>> this be documented?  (The particular issue here would be reading
>>> holes.  It should work by using the zero page, but, if so, we should
>>> probably make it a real documented guarantee.)
>>
>> No, this is not guaranteed. See the previous discussion in v2 on Patch
>> 2/4 between Hugh and me.
>>
>> Summary is: If you want mmap-reads to not fail, use mlock(). There are
>> many situations where a fault might fail (think: OOM) and sealing is
>> not meant to protect against that. Btw., holes are automatically
>> filled with fresh pages by shmem. So a read only fails in OOM
>> situations (or memcg limits, etc.).
>>
>
> Isn't the point of SEAL_SHRINK to allow servers to mmap and read
> safely without worrying about SIGBUS?

No, I don't think so.
The point of SEAL_SHRINK is to prevent a file from shrinking. SIGBUS
is an effect, not a cause. It's only a coincidence that "OOM during
reads" and "reading beyond file-boundaries" has the same effect:
SIGBUS.
We only protect against reading beyond file-boundaries due to
shrinking. Therefore, OOM-SIGBUS is unrelated to SEAL_SHRINK.

Anyone dealing with mmap() _has_ to use mlock() to protect against
OOM-SIGBUS. Making SEAL_SHRINK protect against OOM-SIGBUS would be
redundant, because you can achieve the same with SEAL_SHRINK+mlock().

Thanks
David

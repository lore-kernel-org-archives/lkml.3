Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaHPJy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 05:54:59 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43168 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaHPJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 05:54:57 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <1558893.86R7jAYGB3@vostro.rjw.lan>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1p8=gPBqf6z-YpRzSE=raNJmJw-OKCsLwne3raCr4Y-1g@mail.gmail.com>
 <CALGCz1ofVwspov3QU1rk3z5HBRuDuKxwk1Qkx2xM3vFAVLzS2g@mail.gmail.com> <1558893.86R7jAYGB3@vostro.rjw.lan>
From: Markus Gutschke <markus@gutschke.com>
Date: Sat, 16 Aug 2014 02:54:35 -0700
X-Google-Sender-Auth: c2cLdTJ3cTaaNzbOf29oFhbSpxM
Message-ID: <CALGCz1pk4G3MGiWgabU=qHi9L46Pgp7zJB1TsdKTpiLpd8VgUA@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a1134b5b8442b460500bc2176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1134b5b8442b460500bc2176
Content-Type: text/plain; charset=UTF-8

I collected all the data that you asked for and attached it to the
bug: https://bugzilla.kernel.org/show_bug.cgi?id=80911

Yes, both acpidump output and the list of PNP devices changes when I
update the kernel. I was hoping to give you a brief "diff" output for
the changes; but there are too many changes for that to make much
sense. In any case, you can see it by running:

  diff -u last-good/dirtree_\!sys\!devices\!pnp0.txt
first-bad/dirtree_\!sys\!devices\!pnp0.txt

I included a README.txt that describes the contents of all the files.
I hope this makes some sense and I hope it is sufficiently complete
for you to make progress in debugging why my machine is unhappy.
Please don't hesitate to ask, if you think I can provide other data
and/or run other tests.


Markus


On Fri, Aug 15, 2014 at 5:46 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, August 15, 2014 10:17:42 AM Markus Gutschke wrote:
>> Just wondering if any of you had any other ideas of what I could try
>> to help debug this problem?
>
> My theory is that there is a device in your system that we don't have a driver
> for, but it had been enumerated as a PNP device before the change that triggered
> the problem for you and we turned it off during suspend as part of the default
> ACPI PNP device handling.
>
> The reason why you're seeing a crash with the "platform" test level is most
> likely that the _WAK control method does something unusual on your system.
>
> The LNXSYBUS:00 thing from dmesg probably is a red herring.
>
> I need the output of acpidump from the affected system, but please attach it
> to the bug entry at https://bugzilla.kernel.org/show_bug.cgi?id=80911 that
> Rui has created for this issue.
>
> Also please check the list of PNP devices under
>
> /sys/bus/pnp/devices/
>
> before and after the commit you have found by bisection and let me know if
> there are any differences.
>
>
>> On Tue, Aug 12, 2014 at 9:11 AM, Markus Gutschke <markus@gutschke.com> wrote:
>> > As I said earlier in this thread, echo'ing "devices" into "pm_test"
>> > does not result in a crash; but doing so for "platform" does.
>> >
>> > Markus
>> >
>> > On Aug 12, 2014 1:26 AM, "Zhang Rui" <rui.zhang@intel.com> wrote:
>> >>
>> >> On Sat, 2014-08-09 at 03:14 -0700, Markus Gutschke wrote:
>> >> > I am back and have physical access to the machine now.
>> >> >
>> >> great!
>> >>
>> >> > I re-ran the test just to be sure, and I can confirm that "platform"
>> >> > does in fact result in a crash.
>> >> >
>> >> what about "devices"?
>> >> I mean
>> >>
>> >> # echo devices > /sys/power/pm_test
>> >>
>> >> and see if that triggers the crash.
>> >>
>> >> > Furthermore, I ran the test that Rui asked for. I suspended, resumed,
>> >> > and upon crashing power-cycled the machine ASAP. "dmesg" suggests that
>> >> > the problem is with LNXSYBUS:00 That doesn't tell me much, but
>> >> > hopefully it makes sense to you guys.
>> >> >
>> >> [    0.930093]   Magic number: 10:810:122
>> >> [    0.930185] acpi LNXSYBUS:00: hash matches
>> >>
>> >> This looks weird, ACPI will do nothing for LNXSYBUS devices during
>> >> resume.
>> >> Rafael, any thought on this?
>> >>
>> >> thanks,
>> >> rui
>> >>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

--001a1134b5b8442b460500bc2176
Content-Type: text/plain; charset=US-ASCII; name="README.txt"
Content-Disposition: attachment; filename="README.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hywrp7r00

VGhpcyBhcmNoaXZlIGNvbnRhaW5zIGRlYnVnZ2luZyBpbmZvcm1hdGlvbiByZXRyaWV2ZWQgZm9y
IHRoZSBmb2xsb3dpbmcga2VybmVsCnZlcnNpb25zOgoKNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1
ZjExNjk5ZDZkNzNkZTExYzogTGludXggMy4xNAoxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVk
ZGZmZTVhZmQ5ZDBkOiBMaW51eCAzLjE1CmFjYTBhNGViNGUzMjU5MTRkZGIyMmE4ZWQwNmZjYjAy
MjJkYTJhMjY6IExhc3QgZ29vZCBjb21taXQKZWVjMTVlZGJiMGUxNDQ4NTk5ODYzNWVhN2M2MmUz
MDkxMWI0NjVmMDogRmlyc3QgYmFkIGNvbW1pdApiMDRjNThiMWVkMjYzMTdiZmI0YjMzZDNhMmQx
NjM3N2ZjNmFjZDBmOiBTdGlsbCBiYWQgKG1lcmdlIGJyYW5jaCAiYWNwaS1lbnVtZXJhdGlvbiIp
CmIwNGM1OGIxZWQyNjMxN2JmYjRiMzNkM2EyZDE2Mzc3ZmM2YWNkMGYuUEFUQ0hFRDogUGF0Y2hl
ZCB3aXRoIGEgZGVidWcgcGF0Y2ggcHJvdmlkZWQgYnkgUnVpCgpBZnRlciBlZWMxNWVkYmIwZTE0
NDg1OTk4NjM1ZWE3YzYyZTMwOTExYjQ2NWYwLCB0aGUga2VybmVsIGNhbiBubyBsb25nZXIgcmVz
dW1lCmZyb20gc3VzcGVuZC4gVGhlIGNyYXNoIGxvb2tzIGxpa2Ugd2hhdCBpcyBzaG93biBpbiAi
Y3Jhc2gucG5nIi4KCkV2ZW4gZm9yIGRlZmVjdGl2ZSBrZXJuZWxzLCAiZWNobyBkZXZpY2VzID4v
c3lzL3Bvd2VyL3BtX3Rlc3QiIGNvbXBsZXRlcyBzdWNjZXNzZnVsbHksCndoZXJlYXMgImVjaG8g
cGxhdGZvcm0gPi9zeXMvcG93ZXIvcG1fdGVzdCIgdHJpZ2dlcnMgdGhlIGNyYXNoLgoKQ09ORklH
X1BNX1RSQUNFX1JUQyBzdWdnZXN0cyB0aGF0IHRoZSBidWcgaXMgY2F1c2VkIGJ5IExOWFNZQlVT
OjAwOiwgYnV0IHRoYXQgbWlnaHQgYmUKaW5jb3JyZWN0LgoKUGxlYXNlIG5vdGUgdGhhdCAiZG1l
c2ciIHNob3dzIGFuIGVhcmx5IHN0YWNrIHRyYWNlIGR1cmluZyBib290LiBUaGlzIG1pZ2h0IG9y
IG1pZ2h0Cm5vdCBiZSByZWxhdGVkLgoKUGxlYXNlIGFsc28gbm90IHRoYXQgdGhlIG91dHB1dCBm
cm9tICJhY3BpZHVtcCIgY2hhbmdlcyBiZXR3ZWVuIGtlcm5lbCB2ZXJzaW9ucy4KCkkgYWxzbyBp
bmNsdWRlZCB0aGUgb3V0cHV0IGZyb20KICBncmVwIC4gL3N5cy9idXMvcG5wL2RldmljZXMvKi9m
aXJtd2FyZV9ub2RlLyoKICBncmVwIC4gL3N5cy9idXMvcG5wL2RldmljZXMvKi8qCiAgZ3JlcCAu
IC9zeXMvYnVzL3BsYXRmb3JtL2RldmljZXMvKi9maXJtd2FyZV9ub2RlLyoKICBncmVwIC4gL3N5
cy9idXMvcGxhdGZvcm0vZGV2aWNlcy8qLyoKZm9yIGVhY2ggb2YgdGhlIGtlcm5lbHMuCgpBbmQg
dGhlIGRpcmVjdG9yeSB0cmVlIHVuZGVybmVhdGggL3N5cy9idXMvcG5wL2RldmljZXMvIC0+IC9z
eXMvZGV2aWNlcy9wbnAwLy4K
--001a1134b5b8442b460500bc2176--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3LKWvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:51:44 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44043 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LKWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131211193647.GA25483@xanatos>
References: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1312111204220.1531-100000@iolanthe.rowland.org>
	<CAODwPW_ZUgHWymOF7Fzxh7sbhrvV0-g-pMXWQm=eSz2U8EBRtQ@mail.gmail.com>
	<20131211193647.GA25483@xanatos>
Date: Wed, 11 Dec 2013 14:51:39 -0800
Message-ID: <CAA9_cme4XmXqQfx9kTPEJWdx2XwBZk-G8s7pjSuZ5KWg3UZZ8Q@mail.gmail.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
From: Dan Williams <dan.j.williams@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: multipart/mixed; boundary=089e015372ee75c97c04ed4a1228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e015372ee75c97c04ed4a1228
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Dec 11, 2013 at 11:36 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Wed, Dec 11, 2013 at 11:00:13AM -0800, Julius Werner wrote:
>> > I don't know what you mean by "fails".  The system goes to sleep and
>> > then later on wakes up, doesn't it?
>> >
>> > Do you mean that the Jetflash device gets disconnected when the system
>> > wakes up?  That's _supposed_ to happen under those circumstances.
>> > When hub_activate() sees HUB_RESET_RESUME, all child devices get
>> > disconnected except those where udev->persist_enabled is set.
>>
>> This patch was written in response to the same bug as my "usb: hub:
>> Use correct reset for wedged USB3 devices that are NOTATTACHED"
>> submission. My patch only helps when the port gets stuck in Compliance
>> Mode, but Vikas reports that he can sometimes see it stuck in Polling
>> or Recovery states as well.
>>
>> The underlying issue is a deadlock in the USB 3.0 link training state
>> machine when the host controller is unilaterally reset on resume
>> (without driving a reset on the bus).
>
> The xHCI spec requires that when the xHCI host is reset, a USB reset is
> driven down the USB 3.0 ports.  If hot reset fails, the port may migrate
> to warm reset.  See table 32 in the xHCI spec, in the definition of
> HCRST.  It sounds like this host doesn't drive a USB reset down USB 3.0
> ports at all on host controller reset?

...although, the spec says that it does not wait for the port resets
to complete.  As far as I can see re-issuing a warm reset and waiting
is the only way to guarantee the core times the recovery.  Presumably
the portstatus debounce in hub_activate() mitigates this, but that
100ms is less than a full reset timeout.  I have something similar in
the port power rework patches [1], but I think something like the
following (untested) is more generic, it arranges for reset_resume to
start with a warm reset if necessary.

(also attached)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a7c04e24ca48..30ce237569dd 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2783,8 +2783,14 @@ static int check_port_resume_type(struct
usb_device *udev,
                struct usb_hub *hub, int port1,
                int status, unsigned portchange, unsigned portstatus)
 {
+       /* Did the port go SS.Inactive?  Even if ->persist_enabled is
cleared the
+        * device won't come back until a warm reset completes
+        */
+       if (hub_port_warm_reset_required(hub, portstatus)) {
+               udev->reset_resume = 1;
+               udev->reset_resume_warm = 1;
        /* Is the device still present? */
-       if (status || port_is_suspended(hub, portstatus) ||
+       } else if (status || port_is_suspended(hub, portstatus) ||
                        !port_is_power_on(hub, portstatus) ||
                        !(portstatus & USB_PORT_STAT_CONNECTION)) {
                if (status >= 0)
@@ -4022,7 +4028,8 @@ hub_port_init (struct usb_hub *hub, struct
usb_device *udev, int port1,

        /* Reset the device; full speed may morph to high speed */
        /* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
-       retval = hub_port_reset(hub, port1, udev, delay, false);
+       retval = hub_port_reset(hub, port1, udev, delay,
+                               udev->reset_resume_warm);
        if (retval < 0)         /* error or disconnect */
                goto fail;
        /* success, speed is known */
@@ -4730,7 +4737,8 @@ static void hub_events(void)

                /* deal with port status changes */
                for (i = 1; i <= hdev->maxchild; i++) {
-                       if (test_bit(i, hub->busy_bits))
+                       if (test_bit(i, hub->busy_bits) ||
+                           test_bit(i, hub->delayed_change_bits))
                                continue;
                        connect_change = test_bit(i, hub->change_bits);
                        wakeup_change = test_and_clear_bit(i, hub->wakeup_bits);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7454865ad148..ff1b6fe4a0ff 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -572,6 +572,7 @@ struct usb_device {

        unsigned do_remote_wakeup:1;
        unsigned reset_resume:1;
+       unsigned reset_resume_warm:1;
        unsigned port_is_suspended:1;
 #endif
        struct wusb_dev *wusb_dev;

>
>> The host port starts out back in
>> Rx.Detect without remembering anything about its previous state, but
>> the device is still in U3. The host detects Rx terminations, moves to
>> Polling and starts sending LFPS link training packets, but the device
>> doesn't expect those and interprets them as link problems (moving to
>> Recovery). What happens next seems to be device specific, but
>> apparently the device can end up in SS.Inactive while the host port
>> gets stuck in Polling or Recovery (or some kind of livelock between
>> those).

In testing the port power patches I see this particular device give up
on its superspeed connection if it sees too many link failures and
fallsback to connecting via its high speed connection.

>> This patch tries to warm reset all USB 3.0 ports on reset-resume
>> (after xhci_reset() was called) that had devices connected to them
>> before suspend. This seems to be the only way to ensure the devices'
>> state machines get back to a well-defined state that the host can work
>> with. I don't think this is a specific hardware bug, it's just an
>> unfortunate design flaw that the USB 3.0 spec doesn't account for a
>> root hub port being reset independently of its connected device. I
>> think Sarah is correct that it could be limited to root hubs, though.
>

I think we also need something like the following to hold off khubd
while further resume actions may be taking place.  Again we're
mitigated by the debounce delay in most cases, but if a warm reset
recovery is going to take longer than that khubd needs to be held off
for the given port.

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 30ce237569dd..a99e3eb28aa5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1173,22 +1173,25 @@ static void hub_activate(struct usb_hub *hub,
enum hub_activation_type type)
                                                port_resumed))
                                set_bit(port1, hub->change_bits);

-               } else if (udev->persist_enabled) {
+               } else {
                        struct usb_port *port_dev = hub->ports[port1 - 1];

+                       if (udev->persist_enabled) {
 #ifdef CONFIG_PM
-                       udev->reset_resume = 1;
+                               udev->reset_resume = 1;
 #endif
-                       /* Don't set the change_bits when the device
-                        * was powered off.
-                        */
-                       if (port_dev->power_is_on)
-                               set_bit(port1, hub->change_bits);
+                               /* Don't set the change_bits when the device
+                                * was powered off.
+                                */
+                               if (port_dev->power_is_on)
+                                       set_bit(port1, hub->change_bits);
+                       }

-               } else {
-                       /* The power session is gone; tell khubd */
-                       usb_set_device_state(udev, USB_STATE_NOTATTACHED);
-                       set_bit(port1, hub->change_bits);
+                       /* The power session may be gone; wait for port
+                        * recovery before letting khubd take action on
+                        * this port
+                        */
+                       set_bit(port1, hub->delayed_change_bits);
                }
        }

@@ -3285,6 +3288,11 @@ int usb_port_resume(struct usb_device *udev,
pm_message_t msg)
                usb_unlocked_enable_lpm(udev);
        }

+       if (test_and_clear_bit(port1, hub->delayed_change_bits)) {
+               set_bit(port1, hub->change_bits);
+               kick_khubd(hub);
+       }
+
        return status;
 }

diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index 4e4790dea343..74e87c0380f8 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -45,8 +45,9 @@ struct usb_hub {
        unsigned long           event_bits[1];  /* status change bitmask */
        unsigned long           change_bits[1]; /* ports with logical connect
                                                        status change */
-       unsigned long           busy_bits[1];   /* ports being reset or
-                                                       resumed */
+       unsigned long           busy_bits[1];   /* ports being reset */
+       unsigned long           delayed_change_bits[1]; /* ports awaiting
+                                                          recovery */
        unsigned long           removed_bits[1]; /* ports with a "removed"
                                                        device present */
        unsigned long           wakeup_bits[1]; /* ports that have signaled

--089e015372ee75c97c04ed4a1228
Content-Type: application/octet-stream; name=warm-reset-resume
Content-Disposition: attachment; filename=warm-reset-resume
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp351e8y0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvZHJpdmVyLmMgYi9kcml2ZXJzL3VzYi9jb3Jl
L2RyaXZlci5jCmluZGV4IDhkOTg5YjFkM2RjNS4uMzI3YjkyN2FmYjUyIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3VzYi9jb3JlL2RyaXZlci5jCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvZHJpdmVyLmMK
QEAgLTEzMzMsOCArMTMzMywxMCBAQCBzdGF0aWMgaW50IHVzYl9yZXN1bWVfYm90aChzdHJ1Y3Qg
dXNiX2RldmljZSAqdWRldiwgcG1fbWVzc2FnZV90IG1zZykKIAogIGRvbmU6CiAJZGV2X3ZkYmco
JnVkZXYtPmRldiwgIiVzOiBzdGF0dXMgJWRcbiIsIF9fZnVuY19fLCBzdGF0dXMpOwotCWlmICgh
c3RhdHVzKQorCWlmICghc3RhdHVzKSB7CiAJCXVkZXYtPnJlc2V0X3Jlc3VtZSA9IDA7CisJCXVk
ZXYtPnJlc2V0X3Jlc3VtZV93YXJtID0gMDsKKwl9CiAJcmV0dXJuIHN0YXR1czsKIH0KIApkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2IvY29yZS9odWIuYyBiL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMK
aW5kZXggYTdjMDRlMjRjYTQ4Li4zMGNlMjM3NTY5ZGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNi
L2NvcmUvaHViLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9odWIuYwpAQCAtMjc4Myw4ICsyNzgz
LDE0IEBAIHN0YXRpYyBpbnQgY2hlY2tfcG9ydF9yZXN1bWVfdHlwZShzdHJ1Y3QgdXNiX2Rldmlj
ZSAqdWRldiwKIAkJc3RydWN0IHVzYl9odWIgKmh1YiwgaW50IHBvcnQxLAogCQlpbnQgc3RhdHVz
LCB1bnNpZ25lZCBwb3J0Y2hhbmdlLCB1bnNpZ25lZCBwb3J0c3RhdHVzKQogeworCS8qIERpZCB0
aGUgcG9ydCBnbyBTUy5JbmFjdGl2ZT8gIEV2ZW4gaWYgLT5wZXJzaXN0X2VuYWJsZWQgaXMgY2xl
YXJlZCB0aGUKKwkgKiBkZXZpY2Ugd29uJ3QgY29tZSBiYWNrIHVudGlsIGEgd2FybSByZXNldCBj
b21wbGV0ZXMKKwkgKi8KKwlpZiAoaHViX3BvcnRfd2FybV9yZXNldF9yZXF1aXJlZChodWIsIHBv
cnRzdGF0dXMpKSB7CisJCXVkZXYtPnJlc2V0X3Jlc3VtZSA9IDE7CisJCXVkZXYtPnJlc2V0X3Jl
c3VtZV93YXJtID0gMTsKIAkvKiBJcyB0aGUgZGV2aWNlIHN0aWxsIHByZXNlbnQ/ICovCi0JaWYg
KHN0YXR1cyB8fCBwb3J0X2lzX3N1c3BlbmRlZChodWIsIHBvcnRzdGF0dXMpIHx8CisJfSBlbHNl
IGlmIChzdGF0dXMgfHwgcG9ydF9pc19zdXNwZW5kZWQoaHViLCBwb3J0c3RhdHVzKSB8fAogCQkJ
IXBvcnRfaXNfcG93ZXJfb24oaHViLCBwb3J0c3RhdHVzKSB8fAogCQkJIShwb3J0c3RhdHVzICYg
VVNCX1BPUlRfU1RBVF9DT05ORUNUSU9OKSkgewogCQlpZiAoc3RhdHVzID49IDApCkBAIC00MDIy
LDcgKzQwMjgsOCBAQCBodWJfcG9ydF9pbml0IChzdHJ1Y3QgdXNiX2h1YiAqaHViLCBzdHJ1Y3Qg
dXNiX2RldmljZSAqdWRldiwgaW50IHBvcnQxLAogCiAJLyogUmVzZXQgdGhlIGRldmljZTsgZnVs
bCBzcGVlZCBtYXkgbW9ycGggdG8gaGlnaCBzcGVlZCAqLwogCS8qIEZJWE1FIGEgVVNCIDIuMCBk
ZXZpY2UgbWF5IG1vcnBoIGludG8gU3VwZXJTcGVlZCBvbiByZXNldC4gKi8KLQlyZXR2YWwgPSBo
dWJfcG9ydF9yZXNldChodWIsIHBvcnQxLCB1ZGV2LCBkZWxheSwgZmFsc2UpOworCXJldHZhbCA9
IGh1Yl9wb3J0X3Jlc2V0KGh1YiwgcG9ydDEsIHVkZXYsIGRlbGF5LAorCQkJCXVkZXYtPnJlc2V0
X3Jlc3VtZV93YXJtKTsKIAlpZiAocmV0dmFsIDwgMCkJCS8qIGVycm9yIG9yIGRpc2Nvbm5lY3Qg
Ki8KIAkJZ290byBmYWlsOwogCS8qIHN1Y2Nlc3MsIHNwZWVkIGlzIGtub3duICovCkBAIC00NzMw
LDcgKzQ3MzcsOCBAQCBzdGF0aWMgdm9pZCBodWJfZXZlbnRzKHZvaWQpCiAKIAkJLyogZGVhbCB3
aXRoIHBvcnQgc3RhdHVzIGNoYW5nZXMgKi8KIAkJZm9yIChpID0gMTsgaSA8PSBoZGV2LT5tYXhj
aGlsZDsgaSsrKSB7Ci0JCQlpZiAodGVzdF9iaXQoaSwgaHViLT5idXN5X2JpdHMpKQorCQkJaWYg
KHRlc3RfYml0KGksIGh1Yi0+YnVzeV9iaXRzKSB8fAorCQkJICAgIHRlc3RfYml0KGksIGh1Yi0+
ZGVsYXllZF9jaGFuZ2VfYml0cykpCiAJCQkJY29udGludWU7CiAJCQljb25uZWN0X2NoYW5nZSA9
IHRlc3RfYml0KGksIGh1Yi0+Y2hhbmdlX2JpdHMpOwogCQkJd2FrZXVwX2NoYW5nZSA9IHRlc3Rf
YW5kX2NsZWFyX2JpdChpLCBodWItPndha2V1cF9iaXRzKTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvdXNiLmggYi9pbmNsdWRlL2xpbnV4L3VzYi5oCmluZGV4IDc0NTQ4NjVhZDE0OC4uZmYx
YjZmZTRhMGZmIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3VzYi5oCisrKyBiL2luY2x1ZGUv
bGludXgvdXNiLmgKQEAgLTU3Miw2ICs1NzIsNyBAQCBzdHJ1Y3QgdXNiX2RldmljZSB7CiAKIAl1
bnNpZ25lZCBkb19yZW1vdGVfd2FrZXVwOjE7CiAJdW5zaWduZWQgcmVzZXRfcmVzdW1lOjE7CisJ
dW5zaWduZWQgcmVzZXRfcmVzdW1lX3dhcm06MTsKIAl1bnNpZ25lZCBwb3J0X2lzX3N1c3BlbmRl
ZDoxOwogI2VuZGlmCiAJc3RydWN0IHd1c2JfZGV2ICp3dXNiX2RldjsK
--089e015372ee75c97c04ed4a1228
Content-Type: application/octet-stream; name=delay-khubd
Content-Disposition: attachment; filename=delay-khubd
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp3689741

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMgYi9kcml2ZXJzL3VzYi9jb3JlL2h1
Yi5jCmluZGV4IDMwY2UyMzc1NjlkZC4uYTk5ZTNlYjI4YWE1IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3VzYi9jb3JlL2h1Yi5jCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMKQEAgLTExNzMsMjIg
KzExNzMsMjUgQEAgc3RhdGljIHZvaWQgaHViX2FjdGl2YXRlKHN0cnVjdCB1c2JfaHViICpodWIs
IGVudW0gaHViX2FjdGl2YXRpb25fdHlwZSB0eXBlKQogCQkJCQkJcG9ydF9yZXN1bWVkKSkKIAkJ
CQlzZXRfYml0KHBvcnQxLCBodWItPmNoYW5nZV9iaXRzKTsKIAotCQl9IGVsc2UgaWYgKHVkZXYt
PnBlcnNpc3RfZW5hYmxlZCkgeworCQl9IGVsc2UgewogCQkJc3RydWN0IHVzYl9wb3J0ICpwb3J0
X2RldiA9IGh1Yi0+cG9ydHNbcG9ydDEgLSAxXTsKIAorCQkJaWYgKHVkZXYtPnBlcnNpc3RfZW5h
YmxlZCkgewogI2lmZGVmIENPTkZJR19QTQotCQkJdWRldi0+cmVzZXRfcmVzdW1lID0gMTsKKwkJ
CQl1ZGV2LT5yZXNldF9yZXN1bWUgPSAxOwogI2VuZGlmCi0JCQkvKiBEb24ndCBzZXQgdGhlIGNo
YW5nZV9iaXRzIHdoZW4gdGhlIGRldmljZQotCQkJICogd2FzIHBvd2VyZWQgb2ZmLgotCQkJICov
Ci0JCQlpZiAocG9ydF9kZXYtPnBvd2VyX2lzX29uKQotCQkJCXNldF9iaXQocG9ydDEsIGh1Yi0+
Y2hhbmdlX2JpdHMpOworCQkJCS8qIERvbid0IHNldCB0aGUgY2hhbmdlX2JpdHMgd2hlbiB0aGUg
ZGV2aWNlCisJCQkJICogd2FzIHBvd2VyZWQgb2ZmLgorCQkJCSAqLworCQkJCWlmIChwb3J0X2Rl
di0+cG93ZXJfaXNfb24pCisJCQkJCXNldF9iaXQocG9ydDEsIGh1Yi0+Y2hhbmdlX2JpdHMpOwor
CQkJfQogCi0JCX0gZWxzZSB7Ci0JCQkvKiBUaGUgcG93ZXIgc2Vzc2lvbiBpcyBnb25lOyB0ZWxs
IGtodWJkICovCi0JCQl1c2Jfc2V0X2RldmljZV9zdGF0ZSh1ZGV2LCBVU0JfU1RBVEVfTk9UQVRU
QUNIRUQpOwotCQkJc2V0X2JpdChwb3J0MSwgaHViLT5jaGFuZ2VfYml0cyk7CisJCQkvKiBUaGUg
cG93ZXIgc2Vzc2lvbiBtYXkgYmUgZ29uZTsgd2FpdCBmb3IgcG9ydAorCQkJICogcmVjb3Zlcnkg
YmVmb3JlIGxldHRpbmcga2h1YmQgdGFrZSBhY3Rpb24gb24KKwkJCSAqIHRoaXMgcG9ydAorCQkJ
ICovCisJCQlzZXRfYml0KHBvcnQxLCBodWItPmRlbGF5ZWRfY2hhbmdlX2JpdHMpOwogCQl9CiAJ
fQogCkBAIC0zMjg1LDYgKzMyODgsMTEgQEAgaW50IHVzYl9wb3J0X3Jlc3VtZShzdHJ1Y3QgdXNi
X2RldmljZSAqdWRldiwgcG1fbWVzc2FnZV90IG1zZykKIAkJdXNiX3VubG9ja2VkX2VuYWJsZV9s
cG0odWRldik7CiAJfQogCisJaWYgKHRlc3RfYW5kX2NsZWFyX2JpdChwb3J0MSwgaHViLT5kZWxh
eWVkX2NoYW5nZV9iaXRzKSkgeworCQlzZXRfYml0KHBvcnQxLCBodWItPmNoYW5nZV9iaXRzKTsK
KwkJa2lja19raHViZChodWIpOworCX0KKwogCXJldHVybiBzdGF0dXM7CiB9CiAKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL2NvcmUvaHViLmggYi9kcml2ZXJzL3VzYi9jb3JlL2h1Yi5oCmluZGV4
IDRlNDc5MGRlYTM0My4uNzRlODdjMDM4MGY4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3VzYi9jb3Jl
L2h1Yi5oCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvaHViLmgKQEAgLTQ1LDggKzQ1LDkgQEAgc3Ry
dWN0IHVzYl9odWIgewogCXVuc2lnbmVkIGxvbmcJCWV2ZW50X2JpdHNbMV07CS8qIHN0YXR1cyBj
aGFuZ2UgYml0bWFzayAqLwogCXVuc2lnbmVkIGxvbmcJCWNoYW5nZV9iaXRzWzFdOwkvKiBwb3J0
cyB3aXRoIGxvZ2ljYWwgY29ubmVjdAogCQkJCQkJCXN0YXR1cyBjaGFuZ2UgKi8KLQl1bnNpZ25l
ZCBsb25nCQlidXN5X2JpdHNbMV07CS8qIHBvcnRzIGJlaW5nIHJlc2V0IG9yCi0JCQkJCQkJcmVz
dW1lZCAqLworCXVuc2lnbmVkIGxvbmcJCWJ1c3lfYml0c1sxXTsJLyogcG9ydHMgYmVpbmcgcmVz
ZXQgKi8KKwl1bnNpZ25lZCBsb25nCQlkZWxheWVkX2NoYW5nZV9iaXRzWzFdOyAvKiBwb3J0cyBh
d2FpdGluZworCQkJCQkJCSAgIHJlY292ZXJ5ICovCiAJdW5zaWduZWQgbG9uZwkJcmVtb3ZlZF9i
aXRzWzFdOyAvKiBwb3J0cyB3aXRoIGEgInJlbW92ZWQiCiAJCQkJCQkJZGV2aWNlIHByZXNlbnQg
Ki8KIAl1bnNpZ25lZCBsb25nCQl3YWtldXBfYml0c1sxXTsJLyogcG9ydHMgdGhhdCBoYXZlIHNp
Z25hbGVkCg==
--089e015372ee75c97c04ed4a1228--

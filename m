Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaGSPP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 11:15:29 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:45586 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaGSPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 11:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1407191720160.26264@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-5-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.11.1407181339510.15709@namei.org>
	<CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com>
	<alpine.LRH.2.11.1407191720160.26264@namei.org>
Date: Sat, 19 Jul 2014 08:15:25 -0700
X-Google-Sender-Auth: e68khYawxlfmUDogJhqHABGmmik
Message-ID: <CAGXu5jLqzgJMCqkfLT2azk3J5jX_hBiguA3wkimv9wu60_+xHA@mail.gmail.com>
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 12:22 AM, James Morris <jmorris@namei.org> wrote:
> On Fri, 18 Jul 2014, Kees Cook wrote:
>
>> On Thu, Jul 17, 2014 at 8:41 PM, James Morris <jmorris@namei.org> wrote:
>> > On Mon, 14 Jul 2014, Kees Cook wrote:
>> >
>> >> This attaches LSM hooks to the existing firmware loading interfaces:
>> >> filesystem-found firmware and demand-loaded blobs.
>> >
>> >>  static int fw_get_filesystem_firmware(struct device *device,
>> >> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
>> >>               break;
>> >>       case 0:
>> >>               if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
>> >> +                     if (security_kernel_fw_from_file(NULL, fw_buf->data,
>> >> +                                                      fw_buf->size)) {
>> >> +                             fw_load_abort(fw_priv);
>> >> +                             break;
>> >> +                     }
>> >> +
>> >>                       set_bit(FW_STATUS_DONE, &fw_buf->status);
>> >>                       clear_bit(FW_STATUS_LOADING, &fw_buf->status);
>> >>
>> >>
>> >
>> > Can you explain the loading store, and what the semantics are for an LSM
>> > when a NULL is passed as the file?
>>
>> I'm not sure what you mean by "loading store"?
>
> The caller: firmware_loading_store()

Ah, sure! This is part of the existing userspace interface to firmware
loading. It uses a very strange sysfs interface. The existing
interface creates 2 files in /sys: "loading" and "data", and then
issues a uevent. The kernel uevent listener (generally udev) sees the
event, and launches the userspace firmware loader handler. That
handler locates the requested firmware, writes "1" to "loading", then
writes firmware bytes into "data", and when finished, writes "0" to
"loading".

>> When NULL is passed as the file, it means that the firmware was passes
>> a blob, and there is no file backing it:
>
> Where does this blob come from, is cached, built into the kernel, or what?

The firmware_class interface (before this series) uses three
mechanisms to resolve firmware requests. The first is to find a
firmware that is built into the kernel image itself, as part of a
static array of available firmwares. If this isn't found, the second
is to search the filesystem from within kernel space, trying to find a
matching firmware filename. If found, it will open and load it. If
this mechanism fails, it will call out to userspace (using the
uevent-triggered interface I described above).

In all cases, it is up to the caller of request_firmware to decide if
it wants to cache the loaded firmware or not. Once it's done with it,
it releases the memory.

The documentation for the firmware_class interfaces is in
Documentation/firmware_class/README.

With the patch series, the LSM hook sees the userspace-touching loads:
- from kernel built-in: no LSM hook (nonsense to check the static list)
- direct from filesystem: called with file struct
- via uevent /sys "loading"/"data" interface: called with NULL file struct
- via uevent /sys "fd" interface: called with file struct

The reason the "fd" interface was added was because otherwise there's
no way for systems that use the uevent handler to communicate to the
kernel where the bytes being shoved into the "data" interface are
coming from.

-Kees

-- 
Kees Cook
Chrome OS Security

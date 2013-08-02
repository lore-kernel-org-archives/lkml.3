Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3HBVj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:39:58 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:54606 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3HBVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
Date: Fri, 2 Aug 2013 14:39:55 -0700
Message-ID: <CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Cc: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "anton@samba.org" <anton@samba.org>,
        "ccross@android.com" <ccross@android.com>
Content-Type: multipart/mixed; boundary=001a11c2dac4b2e82a04e2fdcc4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2dac4b2e82a04e2fdcc4d
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Aug 1, 2013 at 4:42 PM, Luck, Tony <tony.luck@intel.com> wrote:
> when I rebuilt a plain 3.11-rc3 it didn't log anything via pstore either :-(

Well this turned out to be operator error on my part. 3.11-rc3 does in fact
log errors to pstore and allows them to be retrieved and cleared.

So then I start testing with your 11 patches in place.

First boot was fine - ERST had no records, and pstore mounted OK
(and showed no files).

Then I panic'd the machine and rebooted.  The boot hung when some
rc script printed"

Mounting other filesystems:

I guess something went wrong when pstore found a non-empty ERST.

I added some debug traces and booted again.  This time the boot succeeded
but I saw a GP fault reported from pstore_mkfile(). Possibly in this code:

        spin_lock_irqsave(&allpstore_lock, flags);
        list_for_each_entry(pos, &allpstore, list) {
                if (pos->type == type &&
                    pos->id == id &&
                    pos->psi == psi) {
                        rc = -EEXIST;
                        break;
                }
        }
        spin_unlock_irqrestore(&allpstore_lock, flags);



My other tracing showed that we'd already found two compressed entries in
ERST and were working on a third when this error happened (implying that
my hang had been a panic that failed to print anything to console)

I've attached one of the compressed files that v3.11-rc3 shows in pstore
now.  The "openssl zlib -d" trick you mentioned back in June mostly works
to decode ... but it seems to dump some trailing garbage at the end of
the file.

-Tony

--001a11c2dac4b2e82a04e2fdcc4d
Content-Type: application/octet-stream; 
	name=unknown-erst-5907623178007478273
Content-Disposition: attachment; filename=unknown-erst-5907623178007478273
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjvwzxnw0

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
--001a11c2dac4b2e82a04e2fdcc4d--

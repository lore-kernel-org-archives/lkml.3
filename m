Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3CEX0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:26:10 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51371 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab3CEX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:26:08 -0500
X-Sasl-enc: ZvKEoZKOItpDmfO42pDO7kYAnzmjKRYnLhBSXAbGl5XM 1362525966
Date: Tue, 5 Mar 2013 20:26:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Message-ID: <20130305232603.GA16045@khazad-dum.debian.net>
References: <201303042055.38040.maciej.rutecki@gmail.com>
 <1362504883-9180-1-git-send-email-msb@chromium.org>
 <20130305174838.GA7276@redhat.com>
 <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com>
 <20130305180542.GA12738@redhat.com>
 <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Mar 2013, Mandeep Singh Baines wrote:
> This mutex seems wrong. Its held the entire time the kthread is
> running. I think its used to synchronize on the exit of the kthread. A
> completion would more appropriate in that case.

>From the top of the driver source:

/* Acquired while the poller kthread is running, use to sync start/stop */
static struct mutex hotkey_thread_mutex;

/*
 * Acquire mutex to write poller control variables as an
 * atomic block.
 *
 * Increment hotkey_config_change when changing them if you
 * want the kthread to forget old state.
 *
 * See HOTKEY_CONFIG_CRITICAL_START/HOTKEY_CONFIG_CRITICAL_END
 */
static struct mutex hotkey_thread_data_mutex;
static unsigned int hotkey_config_change;

#define HOTKEY_CONFIG_CRITICAL_START \
        do { \
                mutex_lock(&hotkey_thread_data_mutex); \
                hotkey_config_change++; \
        } while (0);
#define HOTKEY_CONFIG_CRITICAL_END \
        mutex_unlock(&hotkey_thread_data_mutex);


This can likely be modernized a lot.  This code is from 2008, I think it
first shipped in 2.6.25-rc1.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

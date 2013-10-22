Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3JVPOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:14:23 -0400
Received: from services.gouders.net ([141.101.32.176]:48037 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3JVPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:14:21 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, sw@simonwunderlich.de
Subject: Re: [BUG bisected] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
In-Reply-To: <20131022132303.GA14762@pandem0nium> (Simon Wunderlich's message
	of "Tue, 22 Oct 2013 15:23:03 +0200")
References: <gifvruyge3.fsf@karga.hank.lab>
	<20131022132303.GA14762@pandem0nium>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Tue, 22 Oct 2013 17:14:20 +0200
Message-ID: <ghzjq1pcc3.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, Simon, here is the reply to _all_ recipients:

Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> writes:

> Hey Dirk,
>
> thanks a lot for your report. I have looked at your trace and the patch
> again, but so far I'm not sure where the problem comes from. Could you
> please help by providing:
>
>  * your wpa_supplicant config (censor your passwords!) - I guess you have
>    some ad-hoc networks configured?

Hi Simon,

thanks for your quick response.

No need for censorship, I did some quick tests and stripped down my
wpa_supplicant.conf to a single entry.  With this configuration I get a
lot of traces:

ctrl_interface=/var/run/wpa_supplicant
eapol_version=1
ap_scan=1
fast_reauth=1

network={
	frequency=2412
	group=TKIP
	key_mgmt=NONE
	mode=1
	pairwise=NONE
	ssid="Nokia_n9"
}

I will also attach a dmesg output of my tests.

>  * your wpa_supplicant command line parameters when running

It is running with a wpa_cli like this:

/usr/sbin/wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf \
    -W -B -i wlp4s0 -P /var/run/wpa_supplicant-wlp4s0.pid
/usr/bin/wpa_cli -a /etc/wpa_supplicant/wpa_cli.sh \
    -p /var/run/wpa_supplicant -i wlp4s0 -P /var/run/wpa_cli-wlp4s0.pid -B

>  * environment infos - are there IBSS networks next to your notebook?

Here at home (where rabbit and hedgehog say good night to each other ;-)
I get no scan results -- except when I am using WiFi Hotspot on my Nokia
N9 what I use the entry in the above config for.

In the office where we have Wi-Fi networks, I have to comment out
matching config entries to get the traces.

I hope that answers your question -- I am not very fluent in Wi-Fi
terminology.

> From what I've seen so far:
>
>  * the following warning in cfg80211_chandef_usable() fails: 
>
>      if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>
>  * cfg80211_chandef_usable() is most probably called by
>    cfg80211_reg_can_beacon(), which is called from __ieee80211_sta_join_ibss()
>  * the worker appearently creates the IBSS network using ifibss->chandef,
>    which appearently turns out to be invalid.
>  * ifibss->chandef gets initialized from in ieee80211_ibss_join() from the upper
>    level parameters and is not changed later.
>  * at least nl80211 calls reg_can_bacon() as well and checks the chandef before
>    proceeding. wext looks ok too.
>
> Therefore I'm not sure how the chandef gets broken ...

I wished I could simply try to revert commit 3aede78aad2a7e to see if it
indeed is responsible but a simple revert failed.  If you want me to, I
could try to do that manually or whatever you might think helps to
ensure that we look at the proper commit.

Thanks,

Dirk

[  257.446207] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  257.446219] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
[  257.446365] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[  325.100295] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  325.100308] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
[  325.100452] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[  326.267812] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  326.267824] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
[  326.268005] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[  326.268244] wlp4s0: Trigger new scan to find an IBSS to join
[  328.163335] brcmsmac bcma0:0: brcms_ops_bss_info_changed: Beacon enabled: false
[  328.163349] brcmsmac bcma0:0: brcms_ops_bss_info_changed: IBSS joined: false (implement)
[  330.778227] wlp4s0: Trigger new scan to find an IBSS to join
[  333.792921] wlp4s0: Trigger new scan to find an IBSS to join
[  336.791637] wlp4s0: Trigger new scan to find an IBSS to join
[  337.409105] wlp4s0: Creating new IBSS network, BSSID 9e:71:4a:12:ac:57
[  337.409112] ------------[ cut here ]------------
[  337.409124] WARNING: CPU: 0 PID: 1549 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
[  337.409126] Modules linked in: option usb_wwan brcmsmac cordic brcmutil bcma
[  337.409143] CPU: 0 PID: 1549 Comm: kworker/u4:5 Not tainted 3.12.0-rc6+ #20
[  337.409145] Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
[  337.409155] Workqueue: phy0 ieee80211_iface_work
[  337.409159]  0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
[  337.409164]  ffffffff81068b00 ffff88006dd607c0 ffffffff815e79e4 0000000000000000
[  337.409168]  000000000000000f ffff88006fc63dc2 ffff88006fc63d50 ffff88006fe1e200
[  337.409174] Call Trace:
[  337.409185]  [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
[  337.409193]  [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
[  337.409198]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  337.409202]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  337.409207]  [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
[  337.409213]  [<ffffffff8161b8cd>] ? printk+0x4f/0x54
[  337.409218]  [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
[  337.409223]  [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
[  337.409230]  [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
[  337.409236]  [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
[  337.409241]  [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
[  337.409246]  [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
[  337.409252]  [<ffffffff8107ff37>] ? kthread+0xad/0xb5
[  337.409264]  [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
[  337.409271]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  337.409284]  [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
[  337.409292]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  337.409297] ---[ end trace 8c9c4e19c81db3fc ]---
[  337.409301] wlp4s0: Failed to join IBSS, beacons forbidden
[  340.018245] brcmsmac bcma0:0: brcms_ops_bss_info_changed: Beacon enabled: false
[  340.018256] brcmsmac bcma0:0: brcms_ops_bss_info_changed: IBSS joined: false (implement)
[  342.773061] wlp4s0: Trigger new scan to find an IBSS to join
[  345.787767] wlp4s0: Trigger new scan to find an IBSS to join
[  348.786469] wlp4s0: Trigger new scan to find an IBSS to join
[  349.403920] wlp4s0: Creating new IBSS network, BSSID 3a:7b:c4:91:7f:7f
[  349.403927] ------------[ cut here ]------------
[  349.403939] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
[  349.403941] Modules linked in: option usb_wwan brcmsmac cordic brcmutil bcma
[  349.403956] CPU: 0 PID: 1550 Comm: kworker/u4:6 Tainted: G        W    3.12.0-rc6+ #20
[  349.403958] Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
[  349.403965] Workqueue: phy0 ieee80211_iface_work
[  349.403968]  0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
[  349.403973]  ffffffff81068b00 ffff88006dd607c0 ffffffff815e79e4 0000000000000000
[  349.403978]  000000000000000f ffff88006fc43dc2 ffff88006fc43d50 ffff88006fe1e200
[  349.403983] Call Trace:
[  349.403995]  [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
[  349.404003]  [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
[  349.404007]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  349.404011]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  349.404016]  [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
[  349.404022]  [<ffffffff8161b8cd>] ? printk+0x4f/0x54
[  349.404027]  [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
[  349.404032]  [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
[  349.404039]  [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
[  349.404045]  [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
[  349.404050]  [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
[  349.404055]  [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
[  349.404060]  [<ffffffff8107ff37>] ? kthread+0xad/0xb5
[  349.404065]  [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
[  349.404070]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  349.404076]  [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
[  349.404081]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  349.404084] ---[ end trace 8c9c4e19c81db3fd ]---
[  349.404087] wlp4s0: Failed to join IBSS, beacons forbidden
[  351.877102] brcmsmac bcma0:0: brcms_ops_bss_info_changed: Beacon enabled: false
[  351.877112] brcmsmac bcma0:0: brcms_ops_bss_info_changed: IBSS joined: false (implement)
[  355.767433] wlp4s0: Trigger new scan to find an IBSS to join
[  358.782189] wlp4s0: Trigger new scan to find an IBSS to join
[  359.399618] wlp4s0: Creating new IBSS network, BSSID 66:8d:31:ac:40:2a
[  359.399626] ------------[ cut here ]------------
[  359.399638] WARNING: CPU: 1 PID: 1549 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
[  359.399640] Modules linked in: option usb_wwan brcmsmac cordic brcmutil bcma
[  359.399656] CPU: 1 PID: 1549 Comm: kworker/u4:5 Tainted: G        W    3.12.0-rc6+ #20
[  359.399658] Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
[  359.399664] Workqueue: phy0 ieee80211_iface_work
[  359.399667]  0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
[  359.399672]  ffffffff81068b00 ffff88006dd607c0 ffffffff815e79e4 0000000000000000
[  359.399677]  000000000000000f ffff88006fc63dc2 ffff88006fc63d50 ffff88006fe1e200
[  359.399683] Call Trace:
[  359.399694]  [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
[  359.399702]  [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
[  359.399706]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  359.399711]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  359.399716]  [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
[  359.399721]  [<ffffffff8161b8cd>] ? printk+0x4f/0x54
[  359.399727]  [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
[  359.399731]  [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
[  359.399739]  [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
[  359.399744]  [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
[  359.399749]  [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
[  359.399754]  [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
[  359.399760]  [<ffffffff8107ff37>] ? kthread+0xad/0xb5
[  359.399764]  [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
[  359.399769]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  359.399776]  [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
[  359.399780]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  359.399784] ---[ end trace 8c9c4e19c81db3fe ]---
[  359.399786] wlp4s0: Failed to join IBSS, beacons forbidden
[  361.764903] wlp4s0: Trigger new scan to find an IBSS to join
[  362.382331] wlp4s0: Creating new IBSS network, BSSID 42:b3:7c:d2:ed:eb
[  362.382337] ------------[ cut here ]------------
[  362.382346] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
[  362.382348] Modules linked in: option usb_wwan brcmsmac cordic brcmutil bcma
[  362.382363] CPU: 0 PID: 1550 Comm: kworker/u4:6 Tainted: G        W    3.12.0-rc6+ #20
[  362.382365] Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
[  362.382371] Workqueue: phy0 ieee80211_iface_work
[  362.382373]  0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
[  362.382378]  ffffffff81068b00 ffff88006dd607c0 ffffffff815e79e4 0000000000000000
[  362.382383]  000000000000000f ffff88006fc43dc2 ffff88006fc43d50 ffff88006fe1e200
[  362.382388] Call Trace:
[  362.382397]  [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
[  362.382403]  [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
[  362.382408]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  362.382412]  [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
[  362.382417]  [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
[  362.382422]  [<ffffffff8161b8cd>] ? printk+0x4f/0x54
[  362.382427]  [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
[  362.382432]  [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
[  362.382438]  [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
[  362.382443]  [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
[  362.382448]  [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
[  362.382453]  [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
[  362.382458]  [<ffffffff8107ff37>] ? kthread+0xad/0xb5
[  362.382462]  [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
[  362.382467]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  362.382479]  [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
[  362.382486]  [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
[  362.382491] ---[ end trace 8c9c4e19c81db3ff ]---
[  362.382494] wlp4s0: Failed to join IBSS, beacons forbidden
[  363.739997] brcmsmac bcma0:0: brcms_ops_bss_info_changed: Beacon enabled: false
[  363.740008] brcmsmac bcma0:0: brcms_ops_bss_info_changed: IBSS joined: false (implement)


> Thanks,
> 	Simon
>
> On Mon, Oct 21, 2013 at 02:09:40PM +0200, Dirk Gouders wrote:
>> Hello Simon, all,
>> 
>> Recently, I noticed many traces (find a sample attached) in situations
>> when wpa_supplicant is running but no appropriate access-point available.
>> 
>> I started a bisect and ended at commit 3aede78aad2a7e
>> (mac80211: change IBSS channel state to chandef).
>> 
>> Please let me know if you need more information to inspect this problem.
>> 
>> Best regards,
>> 
>> Dirk
>> 
>> ------------------------------------------------------------------------
>> Oct 21 13:56:06 lena kernel: ------------[ cut here ]------------
>> Oct 21 13:56:06 lena kernel: WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
>> Oct 21 13:56:06 lena kernel: Modules linked in: brcmsmac cordic brcmutil bcma
>> Oct 21 13:56:06 lena kernel: CPU: 0 PID: 1550 Comm: kworker/u4:5 Tainted: G        W    3.12.0-rc6+ #20
>> Oct 21 13:56:06 lena kernel: Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
>> Oct 21 13:56:06 lena kernel: Workqueue: phy0 ieee80211_iface_work
>> Oct 21 13:56:06 lena kernel: 0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
>> Oct 21 13:56:06 lena kernel: ffffffff81068b00 ffff88006f8be7c0 ffffffff815e79e4 0000000000000000
>> Oct 21 13:56:06 lena kernel: 000000000000000f ffff8800703e5dc2 ffff8800703e5d50 ffff88006f8bc200
>> Oct 21 13:56:06 lena kernel: Call Trace:
>> Oct 21 13:56:06 lena kernel: [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
>> Oct 21 13:56:06 lena kernel: [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
>> Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
>> Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
>> Oct 21 13:56:06 lena kernel: [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
>> Oct 21 13:56:06 lena kernel: [<ffffffff8161b8cd>] ? printk+0x4f/0x54
>> Oct 21 13:56:06 lena kernel: [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
>> Oct 21 13:56:06 lena kernel: [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
>> Oct 21 13:56:06 lena kernel: [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107ff37>] ? kthread+0xad/0xb5
>> Oct 21 13:56:06 lena kernel: [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
>> Oct 21 13:56:06 lena kernel: [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
>> Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
>> Oct 21 13:56:06 lena kernel: ---[ end trace ade89af8f1b5d90f ]---
>> ------------------------------------------------------------------------


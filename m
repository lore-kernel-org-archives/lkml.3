Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3LUPuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 10:50:35 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59962 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3LUPuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 10:50:25 -0500
Message-ID: <52B5B8B5.6010909@gmail.com>
Date: Sat, 21 Dec 2013 23:50:13 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: acme@redhat.com, bp@suse.de, gthelen@google.com, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, albcamus@gmail.com
Subject: [PATCH 2/2] tool and script help GDB load Linux kernel modules (script)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getmod.py is a application of KGTP (https://kgtp.googlecode.com) too.

After GDB connected to the gdbstub such as KGTP, KGDB, QEMU, call it with
GDB command "source getmod.py".  Then GDB will auto load all the debug
info of Linux Kernel modules.

Because GDB need parse the struct the data of module list, this script is
slower than getmod.

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
--- /dev/null
+++ b/scripts/getmod.py
@@ -0,0 +1,151 @@
+#!/usr/bin/python
+
+# This script is used by GDB to load the symbols from Linux kernel modules
+# Copyright(C) KGTP team (https://kgtp.googlecode.com), 2011-2013
+# Licensed under the GNU General Public License, version 2.0 (GPLv2)
+
+#Set special mod_search_dir
+#set $mod_search_dir="dir"
+#Clear special mod_search_dir
+#set $mod_search_dir=(void)1
+#Not ignore gtp.ko
+#set $ignore_gtp_ko=0
+
+import gdb
+import os
+
+def get_pagination():
+	buf = gdb.execute("show pagination", False, True)
+	begin = buf.find("State of pagination is ") + len("State of pagination is ")
+	if begin < 0:
+		raise NotImplementedError("Cannot get pagination")
+	buf = buf[begin:]
+	end = buf.rfind(".")
+	buf = buf[:end]
+
+	return buf
+
+pagination = get_pagination()
+gdb.execute("set pagination off", False, False)
+
+def format_file(name):
+	tmp = ""
+	for c in name:
+		if c == "_":
+			c = "-"
+		tmp += c
+	return tmp
+
+#Check if the target is available
+if str(gdb.selected_thread()) == "None":
+	raise gdb.error("Please connect to Linux Kernel before use the script.")
+
+#Output the help
+print "Use GDB command \"set $mod_search_dir=dir\" to set an directory for search the modules."
+
+ignore_gtp_ko = gdb.parse_and_eval("$ignore_gtp_ko")
+if ignore_gtp_ko.type.code == gdb.TYPE_CODE_INT:
+	ignore_gtp_ko = int(ignore_gtp_ko)
+else:
+	ignore_gtp_ko = 1
+
+#Get the mod_search_dir
+mod_search_dir_list = []
+#Get dir from $mod_search_dir
+tmp_dir = gdb.parse_and_eval("$mod_search_dir")
+if tmp_dir.type.code == gdb.TYPE_CODE_ARRAY:
+	tmp_dir = str(tmp_dir)
+	tmp_dir = tmp_dir[1:len(tmp_dir)]
+	tmp_dir = tmp_dir[0:tmp_dir.index("\"")]
+	mod_search_dir_list.append(tmp_dir)
+#Get dir that same with current vmlinux
+tmp_dir = str(gdb.execute("info files", False, True))
+tmp_dir = tmp_dir[tmp_dir.index("Symbols from \"")+len("Symbols from \""):len(tmp_dir)]
+tmp_dir = tmp_dir[0:tmp_dir.index("\"")]
+tmp_dir = tmp_dir[0:tmp_dir.rindex("/")]
+mod_search_dir_list.append(tmp_dir)
+#Get the dir of current Kernel
+tmp_dir = "/lib/modules/" + str(os.uname()[2])
+if os.path.isdir(tmp_dir):
+	mod_search_dir_list.append(tmp_dir)
+#Let user choice dir
+mod_search_dir = ""
+while mod_search_dir == "":
+	for i in range(0, len(mod_search_dir_list)):
+		print str(i)+". "+mod_search_dir_list[i]
+	try:
+		s = input('Select a directory for search the modules [0]:')
+	except SyntaxError:
+		s = 0
+	except:
+		continue
+	if s < 0 or s >= len(mod_search_dir_list):
+		continue
+	mod_search_dir = mod_search_dir_list[s]
+
+mod_list_offset = long(gdb.parse_and_eval("((size_t) &(((struct module *)0)->list))"))
+mod_list = long(gdb.parse_and_eval("(&modules)"))
+mod_list_current = mod_list
+
+while 1:
+	mod_list_current = long(gdb.parse_and_eval("((struct list_head *) "+str(mod_list_current)+")->next"))
+
+	#check if need break the loop
+	if mod_list == mod_list_current:
+		break
+
+	mod = mod_list_current - mod_list_offset
+
+	#get mod_name
+	mod_name = str(gdb.parse_and_eval("((struct module *)"+str(mod)+")->name"))
+	mod_name = mod_name[mod_name.index("\"")+1:len(mod_name)]
+	mod_name = mod_name[0:mod_name.index("\"")]
+	mod_name += ".ko"
+	mod_name = format_file(mod_name)
+
+	#get mod_dir_name
+	mod_dir_name = ""
+	for root, dirs, files in os.walk(mod_search_dir):
+		for afile in files:
+			tmp_file = format_file(afile)
+			if tmp_file == mod_name:
+				mod_dir_name = os.path.join(root,afile)
+				break
+		if mod_dir_name != "":
+			break
+
+	command = " "
+
+	#Add module_core to command
+	tmp = str(gdb.parse_and_eval("((struct module *)"+str(mod)+")->module_core"))
+	if tmp.find('<') >= 0:
+		tmp = tmp[:tmp.index('<')]
+	command += tmp
+
+	#Add each sect_attrs->attrs to command
+	#get nsections
+	nsections = int(gdb.parse_and_eval("((struct module *)"+str(mod)+")->sect_attrs->nsections"))
+	sect_attrs = long(gdb.parse_and_eval("(u64)((struct module *)"+str(mod)+")->sect_attrs"))
+	for i in range(0, nsections):
+		command += " -s"
+		tmp = str(gdb.parse_and_eval("((struct module_sect_attrs *)"+str(sect_attrs)+")->attrs["+str(i)+"].name"))
+		tmp = tmp[tmp.index("\"")+1:len(tmp)]
+		tmp = tmp[0:tmp.index("\"")]
+		command += " "+tmp
+		tmp = str(gdb.parse_and_eval("((struct module_sect_attrs *)"+str(sect_attrs)+")->attrs["+str(i)+"].address"))
+		command += " "+tmp
+
+	if mod_dir_name == "":
+		print "Cannot find out",mod_name,"from directory."
+		print "Please use following command load the symbols from it:"
+		print "add-symbol-file some_dir/"+mod_name+command
+	else:
+		if ignore_gtp_ko and mod_name == "gtp.ko":
+			print "gtp.ko is ignored.  You can use command \"set $ignore_gtp_ko=0\" to close this ignore."
+			print "Or you can use following command load the symbols from it:"
+			print "add-symbol-file "+mod_dir_name+command
+		else:
+			#print "add-symbol-file "+mod_dir_name+command
+			gdb.execute("add-symbol-file "+mod_dir_name+command, False, False)
+
+gdb.execute("set pagination " + pagination, False, False)
